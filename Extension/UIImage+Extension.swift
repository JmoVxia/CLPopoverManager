//
//  UIImage+Extension.swift
//  CKD
//
//  Created by JmoVxia on 2020/2/26.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

extension UIImage {
    /// 生成纯色图片
    class func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    /// 修改图片颜色
    func tintedImage(color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, _: false, _: 0.0)
        let context = UIGraphicsGetCurrentContext()
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        if let context {
            context.setBlendMode(.sourceAtop)
        }
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage
    }

    /// 修正方向图片
    var fixOrientationImage: UIImage {
        guard imageOrientation != .up else { return self }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        guard let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        UIGraphicsEndImageContext()
        return normalizedImage
    }
}

extension UIImage {
    // MARK: - 压缩图片大小

    func compressSize(_ maxSize: Int) -> Data? {
        // 判断是否可以获取JPEG数据
        guard let originalImageData = jpegData(compressionQuality: 1.0) else {
            return nil
        }

        // 如果当前质量满足要求，直接返回
        if originalImageData.count / 1024 <= maxSize {
            return originalImageData
        }

        // 设置默认分辨率
        var defaultSize = CGSize(width: 1024, height: 1024)

        // 尝试调整分辨率
        guard let compressedImage = scaleSize(defaultSize),
              let compressedImageData = compressedImage.jpegData(compressionQuality: 1.0)
        else {
            return nil
        }

        // 初始化最终图片数据
        var finalImageData = compressedImageData

        // 保存压缩系数
        let compressionQualityArray = stride(from: 1.0, to: 0.0, by: -1.0 / 250.0).map { CGFloat($0) }

        // 二分法搜索最佳压缩系数
        if let halfData = binarySearch(array: compressionQualityArray, image: compressedImage, sourceData: finalImageData, maxSize: maxSize) {
            finalImageData = halfData
        }

        // 如果仍未满足要求，降低分辨率
        while finalImageData.count == 0, defaultSize.width > 0, defaultSize.height > 0 {
            defaultSize = CGSize(width: max(defaultSize.width - 100, 0), height: max(defaultSize.height - 100, 0))

            guard let newImageData = compressedImage.jpegData(compressionQuality: compressionQualityArray.last ?? 1.0),
                  let tempImage = UIImage(data: newImageData),
                  let tempCompressedImage = tempImage.scaleSize(defaultSize),
                  let sourceData = tempCompressedImage.jpegData(compressionQuality: 1.0),
                  let halfData = binarySearch(array: compressionQualityArray, image: tempCompressedImage, sourceData: sourceData, maxSize: maxSize)
            else {
                return nil
            }

            finalImageData = halfData
        }

        return finalImageData
    }

    // MARK: - 调整图片分辨率/尺寸（等比例缩放）

    func scaleSize(_ newSize: CGSize) -> UIImage? {
        let heightScale = size.height / newSize.height
        let widthScale = size.width / newSize.width

        var finalSize = size

        if widthScale > 1.0, widthScale > heightScale {
            finalSize.width /= widthScale
            finalSize.height /= widthScale
        } else if heightScale > 1.0, widthScale < heightScale {
            finalSize.width /= heightScale
            finalSize.height /= heightScale
        }

        UIGraphicsBeginImageContextWithOptions(finalSize, false, scale)
        draw(in: CGRect(origin: .zero, size: finalSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }

    // MARK: - 二分法搜索最佳压缩系数

    private func binarySearch(array: [CGFloat], image: UIImage, sourceData: Data, maxSize: Int) -> Data? {
        var finalImageData = Data()
        var start = 0
        var end = array.count - 1

        while start <= end {
            let index = start + (end - start) / 2

            guard let data = image.jpegData(compressionQuality: array[index]) else {
                return nil
            }

            let sizeOrigin = data.count
            let sizeOriginKB = sizeOrigin / 1024

            if sizeOriginKB > maxSize {
                start = index + 1
            } else if sizeOriginKB < maxSize {
                finalImageData = data
                end = index - 1
            } else {
                finalImageData = data
                break
            }
        }

        return finalImageData
    }
}

extension UIImage {
    /// 智能压缩图片大小
    func smartCompressImage() -> Data? {
        guard let finallImageData = jpegData(compressionQuality: 1.0) else { return nil }
        if finallImageData.count / 1024 <= 300 {
            return finallImageData
        }
        var width = size.width
        var height = size.height
        let longSide = max(width, height)
        let shortSide = min(width, height)
        let scale = shortSide / longSide
        if shortSide < 1080 || longSide < 1080 {
            return jpegData(compressionQuality: 0.6)
        } else {
            if width < height {
                width = 1080
                height = 1080 / scale
            } else {
                width = 1080 / scale
                height = 1080
            }
            width = width.rounded(.down)
            height = height.rounded(.down)
            UIGraphicsBeginImageContext(CGSize(width: width, height: height))
            draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            let compressImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return compressImage?.jpegData(compressionQuality: 0.6)
        }
    }
}

extension UIImage {
    /// 截取图片的指定区域，并生成新图片
    /// - Parameter rect: 指定的区域
    func cropping(to rect: CGRect) -> UIImage? {
        let scale = UIScreen.main.scale
        let x = rect.origin.x * scale
        let y = rect.origin.y * scale
        let width = rect.size.width * scale
        let height = rect.size.height * scale
        let croppingRect = CGRect(x: x, y: y, width: width, height: height)
        // 截取部分图片并生成新图片
        guard let sourceImageRef = cgImage else { return nil }
        guard let newImageRef = sourceImageRef.cropping(to: croppingRect) else { return nil }
        let newImage = UIImage(cgImage: newImageRef, scale: scale, orientation: .up)
        return newImage
    }
}
