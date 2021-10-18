/*
 The MIT License (MIT)

 Copyright © 2021 Frank Gregor <phranck@woodbytes.me>

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the “Software”), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

import Foundation
import SwiftUI

internal protocol ApiResource {
    associatedtype ModelType: Decodable

    var id: String? { get }
    var path: ApiPath { get }
    var serialId: String? { get }
    var types: ApiQueryType? { get }
    var category: StationsCategory? { get }
    var query: String? { get }
}

// MARK: - Default Values

extension ApiResource {
    var path: ApiPath { .browse }
}

extension ApiResource {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "opml.radiotime.com"
        components.path = "/\(path.rawValue).ashx"
        components.queryItems = [
            URLQueryItem(name: "render", value: "json"),
            URLQueryItem(name: "formats", value: "mp3,aac,wma,wmpro,wmvoice,ogg,qt"),
        ]

        if let id = id {
            components.queryItems?.append(URLQueryItem(name: "id", value: id))
        }

        if let regionCode = Locale.current.regionCode {
            components.queryItems?.append(URLQueryItem(name: "locale", value: regionCode.lowercased()))
        }

        if let partnerId = RadioTime.partnerId {
            components.queryItems?.append(URLQueryItem(name: "partnerId", value: partnerId))
        }

        if let serialId = serialId {
            components.queryItems?.append(URLQueryItem(name: "serial", value: serialId))
        }

        if let types = types {
            components.queryItems?.append(URLQueryItem(name: "types", value: types.rawValue))
        }

        if let category = category {
            components.queryItems?.append(URLQueryItem(name: "c", value: category.rawValue))
        }

        if let query = query {
            components.queryItems?.append(URLQueryItem(name: "query", value: query))
        }

        return components.url!
    }
}

internal enum ApiQueryType: String {
    case link
    case station
}

internal enum ApiPath: String {
    case browse   = "Browse"
    case search   = "Search"
    case tune     = "Tune"
    case describe = "Describe"
    case account  = "Account"
}

public enum StationsCategory: String {
    case local, music, podcast, talk, sports, trending
}
