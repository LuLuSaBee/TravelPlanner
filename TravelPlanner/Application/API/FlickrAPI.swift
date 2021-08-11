//
//  FlickrAPI.swift
//  TravelPlanner
//
//  Created by Louis SL Liu on 2021/8/10.
//

import Foundation

enum EndPoint: String {
    case interestingPhotos = "flickr.interestingness.getList"
}

struct FlickrResponse: Codable {
    let imagesInfo: FlickrPhotosResponse

    enum CodingKeys: String, CodingKey {
        case imagesInfo = "photos" // flickr
    }
}

struct FlickrPhotosResponse: Codable {
    let images: [Image]

    enum CodingKeys: String, CodingKey {
        case images = "photo"
    }
}

struct FlickrAPI {
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let apiKey = "a6d819499131071f158fd740860a5a88"

    private static func flickrURL(endPoint: EndPoint, parameters: [String: String]?) -> URL {
        var components = URLComponents(string: baseURLString)!
        var queryItems = [URLQueryItem]()

        let baseParams = [
            "method": endPoint.rawValue,
            "format": "json",
            "nojsoncallback": "1",
            "api_key": apiKey
        ]

        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems

        return components.url!
    }

    static var interestingImagesURL: URL {
        return flickrURL(endPoint: .interestingPhotos, parameters: ["extras": "url_z,date_taken"])
    }

    static func images(fromJSON data: Data) -> Result<[Image], Error> {
        do {
            let decoder = JSONDecoder()

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.locale = Locale(identifier: "zh_Hant_TW")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            decoder.dateDecodingStrategy = .formatted(dateFormatter)

            let flickrResponse = try decoder.decode(FlickrResponse.self, from: data)
            let images = flickrResponse.imagesInfo.images.filter { $0.remoteURL != nil }
                    return .success(images)
        } catch {
            return .failure(error)
        }
    }
}
