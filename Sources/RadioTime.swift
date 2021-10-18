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

import CloudUserDefaults
import SwiftUI

public class RadioTime: ObservableObject {
    public static let version = "0.1.2"
    public static let build = 1

    public static var partnerId: String?
    public static var favoritesStorage: RadioTimeFavoritesStorage = .iCloud

    private let cloudUserDefaults = CloudUserDefaults()
    private static let cloudPrefix = "playable"

    @Published public internal(set) var stations: Children = []
    @Published public internal(set) var favorites: Children = []
    @Published public internal(set) var error: RadioTimeError = .none
    @Published public internal(set) var isLoading: Bool = false

    @AppStorage("\(favoritesStorage == .iCloud ? "\(cloudPrefix)_" : "")favorites")
    private var cloudfavorites: Set<Outline> = []

    @AppStorage("\(cloudPrefix)_initialStationsCategory")
    public static var initialStationsCategory: StationsCategory = .trending

    public init() {
        cloudUserDefaults.start(prefix: RadioTime.cloudPrefix)
        favorites = Array(cloudfavorites)

        fetchStations(with: RadioTime.initialStationsCategory)

        NotificationCenter.default.addObserver(self, selector: #selector(cloudUpdate(notification:)), name: CloudUserDefaults.cloudSyncNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: CloudUserDefaults.cloudSyncNotification, object: nil)
    }

    public func fetchStations(with category: StationsCategory) {
        let model: ApiViewModel
        switch category {
            case .local:
                model = BrowseLocalViewModel(api: self)
                model.fetchStations()
            case .trending:
                model = BrowseTrendingViewModel(api: self)
                model.fetchStations()
            default:
                break
        }
    }

    public func addToFavorites(station: Outline) {
        DispatchQueue.main.async {
            self.cloudfavorites.insert(station)
            self.favorites.append(station)
        }
    }

    public func removeFromFavorites(station: Outline) {
        DispatchQueue.main.async {
            self.cloudfavorites.remove(station)
            if let index = self.favorites.firstIndex(of: station) {
                self.favorites.remove(at: index)
            }
        }
    }

    // MARK: - Notifications

    @objc internal func cloudUpdate(notification: NSNotification) {
        if let dict: [String: Any] = notification.object as? [String: Any],
           let favorites = Array<Outline>(rawValue: dict.description) {

            print("Received Cloud Favorites: \(favorites)")
            DispatchQueue.main.async {
                self.favorites = favorites
            }

        }
    }
}

public enum RadioTimeFavoritesStorage {
    case userDefaults, iCloud
}
