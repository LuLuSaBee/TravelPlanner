//
//  PhotoStore.swift
//  TravelPlanner
//
//  Created by Louis SL Liu on 2021/8/10.
//

import UIKit

enum ImageError: Error {
    case imageCreationError
    case missingImageURL
}

class ImageStore {
    // MARK: - Flickr
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()

    private func fetchInterestingImages(completion: @escaping (Result<[Image], Error>) -> Void) {
        let url = FlickrAPI.interestingImagesURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            let result = self.processImagesRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }

    private func processImagesRequest(data: Data?, error: Error?) -> Result<[Image], Error> {
        guard let jsonData = data else {
            return .failure(error!)
        }
        return FlickrAPI.images(fromJSON: jsonData)
    }

    private func fetchImage(for image: Image, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let imageURL = image.remoteURL else {
            completion(.failure(ImageError.missingImageURL))
            return
        }
        let request = URLRequest(url: imageURL)

        let task = session.dataTask(with: request) {
            (data, response, error) in
            let result = self.processImageRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }

    private func processImageRequest(data: Data?, error: Error?) -> Result<UIImage, Error> {
        guard
            let imageData = data,
            let image = UIImage(data: imageData) else {
            if data == nil {
                return .failure(error!)
            } else {
                return .failure(ImageError.imageCreationError)
            }
        }

        return .success(image)
    }

    // MARK: - Sandbox
    private let cache = NSCache<NSString, UIImage>()

    private func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)

        let url = imageURL(forKey: key)

        if let data = image.jpegData(compressionQuality: 0.5) {
            try? data.write(to: url)
        }
    }

    func getImage(forKey key: String) -> UIImage? {
        if let exitingImage = cache.object(forKey: key as NSString) {
            return exitingImage
        }

        let url = imageURL(forKey: key)
        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else {
            return nil
        }

        cache.setObject(imageFromDisk, forKey: key as NSString)
        return imageFromDisk
    }

    func deleteImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)

        let url = imageURL(forKey: key)
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Error removing the image from disk: \(error)")
        }
    }

    private func imageURL(forKey key: String) -> URL {
        let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentDirectories.first!

        return documentDirectory.appendingPathComponent(key)
    }

    // MARK: -
    func fetchRandomImageAndSetByKey(key: String) {
        self.fetchInterestingImages { (photosResult) in
            switch photosResult {
            case let .success(images):
                if !images.isEmpty {
                    self.fetchImage(for: images[Int.random(in: images.startIndex..<images.endIndex)]) {
                        (imageResult) in
                        switch imageResult {
                        case let .success(image):
                            self.setImage(image, forKey: key)
                        case let .failure(error):
                            print("Error downloading image: \(error)")
                        }
                    }
                }
            case let .failure(error):
                print("Error fetching interesting photos: \(error)")
            }
        }
    }
}
