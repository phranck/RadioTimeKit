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
import Regex

public class Outline: Decodable, Identifiable {
    // OPML specified attributes
    public var id: String { presetId }
    public var text: String
    public var subText: String?
    public var type: String?

    public var element: String?
    public var children: Children?

    private var url: String
    public var streamUrl: URL {
        URL(string: url)!
    }

    private var coverUrlString: String?
    public var coverUrl: URL? {
        if let urlString = coverUrlString,
           let url = URL(string: urlString) {
            return url
        }
        return nil
    }

    public var nowPlayingTitle: String?
    private var nowPlayingImageUrlString: String?
    public var nowPlayingImageUrl: URL? {
        if let urlString = nowPlayingImageUrlString,
           let url = URL(string: urlString) {
            return url
        }
        return nil
    }
    public var nowPlayingId: String?

    public var genreId: String?
    public var presetId: String
    public var guideId: String?
    public var bitrate: String?
    public var item: String?
    public var formats: String?
    public var details: Station?

    private enum CodingKeys: String, CodingKey {
        case text
        case subText = "subtext"
        case coverUrlString = "image"
        case url = "URL"
        case element
        case nowPlayingTitle = "playing"
        case nowPlayingImageUrlString = "playing_image"
        case nowPlayingId = "now_playing_id"
        case genreId = "genre_id"
        case presetId = "preset_id"
        case guideId = "guide_id"
        case bitrate = "bitrate"
        case item
        case formats
        case type
        case details
    }

    public init(title: String, subTitle: String, coverUrlString: String, streamUrlString: String, type: String = "audio", bitrate: String = "192", formats: String = "mp3", presetId: String = "s20407") {
        self.text = title
        self.subText = subTitle
        self.coverUrlString = streamUrlString
        self.url = streamUrlString
        self.type = type
        self.bitrate = bitrate
        self.formats = formats
        self.presetId = presetId
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        text = try container.decode(String.self, forKey: .text)
            .replacingFirst(matching: "(.+) (\\d{1,3}\\.\\d{1}) (\\(.+\\))", with: "$1")
            .replacingFirst(matching: "(.+) (\\(.+\\))", with: "$1")

        subText = try container.decodeIfPresent(String.self, forKey: .subText)
        url = try container.decode(String.self, forKey: .url)
        type = try container.decodeIfPresent(String.self, forKey: .type)

        element = try container.decodeIfPresent(String.self, forKey: .element)
        coverUrlString = try container.decodeIfPresent(String.self, forKey: .coverUrlString)
        nowPlayingTitle = try container.decodeIfPresent(String.self, forKey: .nowPlayingTitle)
        nowPlayingImageUrlString = try container.decodeIfPresent(String.self, forKey: .nowPlayingImageUrlString)
        nowPlayingId = try container.decodeIfPresent(String.self, forKey: .nowPlayingId)
        genreId = try container.decodeIfPresent(String.self, forKey: .genreId)
        presetId = try container.decode(String.self, forKey: .presetId)
        guideId = try container.decodeIfPresent(String.self, forKey: .guideId)
        bitrate = try container.decodeIfPresent(String.self, forKey: .bitrate)
        item = try container.decodeIfPresent(String.self, forKey: .item)
        formats = try container.decodeIfPresent(String.self, forKey: .formats)
        details = try container.decodeIfPresent(Station.self, forKey: .details)
    }
}

extension Outline: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(text, forKey: .text)
        try container.encodeIfPresent(subText, forKey: .subText)
        try container.encode(url, forKey: .url)
        try container.encodeIfPresent(type, forKey: .type)

        try container.encodeIfPresent(element, forKey: .element)
        try container.encodeIfPresent(coverUrlString, forKey: .coverUrlString)
        try container.encodeIfPresent(nowPlayingTitle, forKey: .nowPlayingTitle)
        try container.encodeIfPresent(nowPlayingImageUrlString, forKey: .nowPlayingImageUrlString)
        try container.encodeIfPresent(nowPlayingId, forKey: .nowPlayingId)
        try container.encodeIfPresent(genreId, forKey: .genreId)
        try container.encode(presetId, forKey: .presetId)
        try container.encodeIfPresent(guideId, forKey: .guideId)
        try container.encodeIfPresent(bitrate, forKey: .bitrate)
        try container.encodeIfPresent(item, forKey: .item)
        try container.encodeIfPresent(formats, forKey: .formats)
        try container.encodeIfPresent(details, forKey: .details)
    }
}

extension Outline: Equatable {
    public static func == (lhs: Outline, rhs: Outline) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Outline: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(url)
    }
}
