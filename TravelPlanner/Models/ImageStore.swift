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
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()

    func fetchInterestingImages(completion: @escaping (Result<[Image], Error>) -> Void) {

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

    private func processImagesRequest(data: Data?,
        error: Error?) -> Result<[Image], Error> {
        guard let jsonData = data else {
            return .failure(error!)
        }
        return FlickrAPI.images(fromJSON: jsonData)
    }

    func fetchImage(for image: Image,
        completion: @escaping (Result<UIImage, Error>) -> Void) {
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

    private func processImageRequest(data: Data?,
        error: Error?) -> Result<UIImage, Error> {
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
}
