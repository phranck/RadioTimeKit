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

internal protocol NetworkRequest {
    associatedtype ModelType
    func decode(_ data: Data, withCompletion completion: @escaping (Result<ModelType?, RadioTimeError>) -> Void)
    func execute(withCompletion completion: @escaping (Result<ModelType?, RadioTimeError>) -> Void)
}

extension NetworkRequest {
    internal func load(_ url: URL, withCompletion completion: @escaping (Result<ModelType?, RadioTimeError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.cachePolicy = .returnCacheDataElseLoad

        print(request)

        DispatchQueue.global().async {
            let task = URLSession.shared.dataTask(with: request) { data, response, error -> Void in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(RadioTimeError.undefined(error: error)))
                    }
                    return
                }

                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(RadioTimeError.invalidResponseData))
                    }
                    return
                }

                self.decode(data, withCompletion: { result in
                    switch result {
                        case .success(let result):
                            DispatchQueue.main.async {
                                completion(.success(result))
                            }
                        case .failure(let error):
                            DispatchQueue.main.async {
                                completion(.failure(RadioTimeError.jsonDecodingError(error: error)))
                            }
                    }
                })
            }
            task.resume()
        }
    }
}
