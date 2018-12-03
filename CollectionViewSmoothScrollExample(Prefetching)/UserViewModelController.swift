//
//  UserViewModelController.swift
//  CollectionViewSmoothScrollExample(Prefetching)
//
//  Created by David on 06/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

enum NetworkingRelatedResult<T> {
    case success(T)
    case failure(DataFetchingError)
}

enum DataFetchingError: Error {
    case badHttpCode(code: String)
    case nilData
    case unknown(error: Error)
    case parsingError(message: String)
}

typealias GetUsersCompletionBlock = (_ success: Bool, _ error: DataFetchingError?) -> Void

class UserViewModelController {
    private static let pageSize = 25
    private var viewModels: [UserViewModel] = []
    private var currentPage = -1
    private var lastPage = -1
    
    private var getUsersCompletionBlock: GetUsersCompletionBlock?
    
    func getUsers(_ onCompletion: @escaping GetUsersCompletionBlock) {
        getUsersCompletionBlock = onCompletion
        loadNextPageIfNeeded(for: 0)
    }
    
    func viewModel(at index: Int) -> UserViewModel? {
        guard index >= 0 && index < viewModels.count else { return nil }
        loadNextPageIfNeeded(for: index)
        return viewModels[index]
    }
    
    var viewModelsCount: Int { return self.viewModels.count }
    
    func parse<T: Decodable>(_ json: Data) -> NetworkingRelatedResult<T> {
        do {
           let decodedModel = try JSONDecoder().decode(T.self, from: json)
            return .success(decodedModel)
        } catch let decodingError {
            return .failure(DataFetchingError.parsingError(message: decodingError.localizedDescription))
        }
    }
    
    func viewModels(from users: [User]) -> [UserViewModel] {
        return users.map { UserViewModel(user: $0) }
    }
    
    func loadNextPageIfNeeded(for index: Int) {
        let targetCount = currentPage < 0 ? 0 : (currentPage + 1) * UserViewModelController.pageSize - 1
        guard index == targetCount else { return }
        currentPage += 1
        
        let id = currentPage * UserViewModelController.pageSize + 1
        let urlString = String(format: "https://aqueous-temple-22443.herokuapp.com/users?id=\(id)&count=\(UserViewModelController.pageSize)")
        let url = URL(string: urlString)!
        
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: url) { [weak self] (data, response, error) in
            
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.getUsersCompletionBlock?(false, .unknown(error: error))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    self.getUsersCompletionBlock?(false, nil)
                }
                return
            }
            
            let statusCode = httpResponse.statusCode
            
            guard (0...300)~=httpResponse.statusCode else {
                print("Bad Status Code: \(statusCode)")
                self.getUsersCompletionBlock?(false, .badHttpCode(code: "\(statusCode)"))
                return
            }
            
            guard let jsonData = data else {
                
                DispatchQueue.main.async {
                    self.getUsersCompletionBlock?(false, .nilData)
                }
                return
            }
            
            self.lastPage += 1
            
            let parsingResult: NetworkingRelatedResult<[User]> = self.parse(jsonData)
            
            switch parsingResult {
            case .success(let users):
                let userViewModels = self.viewModels(from: users)
                self.viewModels.append(contentsOf: userViewModels)
                DispatchQueue.main.async {
                    self.getUsersCompletionBlock?(true, nil)
                }
                return
            case .failure(let error):
                DispatchQueue.main.async {
                    self.getUsersCompletionBlock?(false, error)
                }
                return
            }
        }
        dataTask.resume()
    }
    
}
