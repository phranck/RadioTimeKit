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

public class Station: Decodable, Identifiable {
    public var id: String { presetId }
    public var presetId: String = ""
    public var name: String = ""
    public var callSign: String = ""
    public var slogan: String = ""
    public var location: String = ""
    public var description: String = ""
    public var email: String = ""
    public var twitterHandle: String = ""
    public var phone: String = ""
    public var mailingAddress: String = ""
    public var genreId: String = ""
    public var genreName: String = ""
    public var regionId: String?
    public var latlon: String?
    public var band: String?
    public var frequency: String?
    public var currentSong: String?
    public var currentArtist: String?
    public var currentAlbum: String?

    private var websiteUrlString: String = ""
    public var websiteUrl: URL? {
        if let url = URL(string: websiteUrlString) {
            return url
        }
        return nil
    }

    private var logoUrlString: String = ""
    public var logoUrl: URL? {
        if let url = URL(string: logoUrlString) {
            return url
        }
        return nil
    }

    private enum CodingKeys: String, CodingKey {
        case presetId = "preset_id"
        case name
        case callSign = "call_sign"
        case slogan
        case websiteUrlString = "url"
        case logoUrlString = "logo"
        case location
        case description
        case email
        case twitterHandle = "twitter_id"
        case phone
        case mailingAddress = "mailing_address"
        case genreId = "genre_id"
        case genreName = "genre_name"
        case regionId = "region_id"
        case latlon
        case band
        case frequency
        case currentSong = "current_song"
        case currentArtist = "current_artist"
        case currentAlbum = "current_album"
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        presetId = try container.decode(String.self, forKey: .presetId)
        name = try container.decode(String.self, forKey: .name)
        callSign = try container.decode(String.self, forKey: .callSign)
        slogan = try container.decode(String.self, forKey: .slogan)
        websiteUrlString = try container.decode(String.self, forKey: .websiteUrlString)
        logoUrlString = try container.decode(String.self, forKey: .logoUrlString)
        location = try container.decode(String.self, forKey: .location)
        description = try container.decode(String.self, forKey: .description)
        email = try container.decode(String.self, forKey: .email)
        twitterHandle = try container.decode(String.self, forKey: .twitterHandle)
        phone = try container.decode(String.self, forKey: .phone)
        mailingAddress = try container.decode(String.self, forKey: .mailingAddress)
        genreId = try container.decode(String.self, forKey: .genreId)
        genreName = try container.decode(String.self, forKey: .genreName)
        regionId = try container.decodeIfPresent(String.self, forKey: .regionId)
        latlon = try container.decodeIfPresent(String.self, forKey: .latlon)
        band = try container.decodeIfPresent(String.self, forKey: .band)
        frequency = try container.decodeIfPresent(String.self, forKey: .frequency)
        currentSong = try container.decodeIfPresent(String.self, forKey: .currentSong)
        currentArtist = try container.decodeIfPresent(String.self, forKey: .currentArtist)
        currentAlbum = try container.decodeIfPresent(String.self, forKey: .currentAlbum)
    }
}

extension Station: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(presetId, forKey: .presetId)
        try container.encode(name, forKey: .name)
        try container.encode(callSign, forKey: .callSign)
        try container.encode(slogan, forKey: .slogan)
        try container.encode(websiteUrlString, forKey: .websiteUrlString)
        try container.encode(logoUrlString, forKey: .logoUrlString)
        try container.encode(location, forKey: .location)
        try container.encode(description, forKey: .description)
        try container.encode(email, forKey: .email)
        try container.encode(twitterHandle, forKey: .twitterHandle)
        try container.encode(phone, forKey: .phone)
        try container.encode(mailingAddress, forKey: .mailingAddress)
        try container.encode(genreId, forKey: .genreId)
        try container.encode(genreName, forKey: .genreName)
        try container.encodeIfPresent(regionId, forKey: .regionId)
        try container.encodeIfPresent(latlon, forKey: .latlon)
        try container.encodeIfPresent(band, forKey: .band)
        try container.encodeIfPresent(frequency, forKey: .frequency)
        try container.encodeIfPresent(currentSong, forKey: .currentSong)
        try container.encodeIfPresent(currentArtist, forKey: .currentArtist)
        try container.encodeIfPresent(currentAlbum, forKey: .currentAlbum)
    }
}

extension Station: Equatable {
    public static func == (lhs: Station, rhs: Station) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Station: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
