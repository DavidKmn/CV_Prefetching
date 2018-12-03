//
//  ViewController.swift
//  CollectionViewSmoothScrollExample(Prefetching)
//
//  Created by David on 06/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

class UserDisplayViewController: UIViewController {

    let cellId = "celId"
    
    lazy var collectionView: UICollectionView = { [unowned self] in
       let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.register(UserCollectionViewCell.self, forCellWithReuseIdentifier: self.cellId)
        cv.dataSource = self
        if #available(iOS 10.0, *) {
         cv.prefetchDataSource = self
        }
        return cv
    }()
    
    // Prefetching Queue
    private let loadImageQueue = OperationQueue()
    private var loadImageOperations = [IndexPath: LoadImageOperation]()
    
    private let userViewModelController = UserViewModelController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userViewModelController.getUsers { [weak self] (success, error) in
            guard let self = self else { return }
            if !success {
                let errorTitle = "Error"
                DispatchQueue.main.async {
                    if let error = error {
                        self.showErrorAlert(withTitle: errorTitle, message: error.localizedDescription)
                    } else {
                        self.showErrorAlert(withTitle: errorTitle)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.frame = view.frame
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [weak self] (context) in
            self?.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }


}

extension UserDisplayViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userViewModelController.viewModelsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserCollectionViewCell
        guard let viewModel = userViewModelController.viewModel(at: indexPath.item) else { return cell }
        cell.configure(viewModel)
        
        if let loadImageOp = loadImageOperations[indexPath], let image = loadImageOp.image {
            cell.avatarImageView.image = image
        } else {
            let loadImageOp = LoadImageOperation(url: viewModel.avatarImageUrl)
            loadImageOp.completionHandler = { [weak self] image in
                guard let self = self else { return }
                cell.avatarImageView.image = image
                self.loadImageOperations.removeValue(forKey: indexPath)
            }
            loadImageQueue.addOperation(loadImageOp)
            loadImageOperations[indexPath] = loadImageOp
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let loadImageOp = self.loadImageOperations[indexPath] else { return }
        loadImageOp.cancel()
        self.loadImageOperations.removeValue(forKey: indexPath)
    }
}

extension UserDisplayViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { (ip) in
            if loadImageOperations[ip] != nil { return }
            
            if let viewModel = userViewModelController.viewModel(at: ip.item) {
                let loadImageOp = LoadImageOperation(url: viewModel.avatarImageUrl)
                loadImageQueue.addOperation(loadImageOp)
                loadImageOperations[ip] = loadImageOp
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { (ip) in
            guard let loadImageOp = loadImageOperations[ip] else { return }
            loadImageOp.cancel()
            loadImageOperations.removeValue(forKey: ip)
        }
    }
    
}


