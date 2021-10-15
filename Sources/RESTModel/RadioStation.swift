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

public class RadioStation: Decodable, Identifiable {
    public var title: String
    public var subTitle: String?

    private var coverUrlString: String?
    public var coverUrl: URL? {
        if let urlString = coverUrlString,
           let url = URL(string: urlString) {
            return url
        }
        return nil
    }

    private var streamUrlString: String
    public var streamUrl: URL {
        URL(string: streamUrlString)!
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
    public var presetId: String?
    public var guideId: String?
    public var bitrate: String?
    public var item: String?
    public var formats: String?
    public var type: String

    private enum CodingKeys: String, CodingKey {
        case title = "text"
        case subTitle = "subtext"
        case coverUrlString = "image"
        case streamUrlString = "URL"
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
    }

    public init(title: String, subTitle: String, coverUrlString: String, streamUrlString: String, type: String = "audio", bitrate: String = "192", formats: String = "mp3") {
        self.title = title
        self.subTitle = subTitle
        self.coverUrlString = streamUrlString
        self.streamUrlString = streamUrlString
        self.type = type
        self.bitrate = bitrate
        self.formats = formats
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        title = try container.decode(String.self, forKey: .title)
            .replacingFirstMatch(of: "(.+) (\\d{1,3}\\.\\d{1}) (\\(.+\\))", with: "$1")
            .replacingFirstMatch(of: "(.+) (\\(.+\\))", with: "$1")

        subTitle = try container.decodeIfPresent(String.self, forKey: .subTitle)
        coverUrlString = try container.decodeIfPresent(String.self, forKey: .coverUrlString)
        streamUrlString = try container.decode(String.self, forKey: .streamUrlString)
        nowPlayingTitle = try container.decodeIfPresent(String.self, forKey: .nowPlayingTitle)
        nowPlayingImageUrlString = try container.decodeIfPresent(String.self, forKey: .nowPlayingImageUrlString)
        nowPlayingId = try container.decodeIfPresent(String.self, forKey: .nowPlayingId)
        genreId = try container.decodeIfPresent(String.self, forKey: .genreId)
        presetId = try container.decodeIfPresent(String.self, forKey: .presetId)
        guideId = try container.decodeIfPresent(String.self, forKey: .guideId)
        bitrate = try container.decodeIfPresent(String.self, forKey: .bitrate)
        item = try container.decodeIfPresent(String.self, forKey: .item)
        formats = try container.decodeIfPresent(String.self, forKey: .formats)
        type = try container.decode(String.self, forKey: .type)
    }
}

extension RadioStation: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(subTitle, forKey: .subTitle)
        try container.encodeIfPresent(coverUrlString, forKey: .coverUrlString)
        try container.encode(streamUrlString, forKey: .streamUrlString)
        try container.encodeIfPresent(nowPlayingTitle, forKey: .nowPlayingTitle)
        try container.encodeIfPresent(nowPlayingImageUrlString, forKey: .nowPlayingImageUrlString)
        try container.encodeIfPresent(nowPlayingId, forKey: .nowPlayingId)
        try container.encodeIfPresent(genreId, forKey: .genreId)
        try container.encodeIfPresent(presetId, forKey: .presetId)
        try container.encodeIfPresent(guideId, forKey: .guideId)
        try container.encodeIfPresent(bitrate, forKey: .bitrate)
        try container.encodeIfPresent(item, forKey: .item)
        try container.encodeIfPresent(formats, forKey: .formats)
        try container.encode(type, forKey: .type)
    }
}

extension RadioStation: Equatable {
    public static func == (lhs: RadioStation, rhs: RadioStation) -> Bool {
        return lhs.presetId == rhs.presetId
    }
}

extension RadioStation: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(presetId)
    }
}
