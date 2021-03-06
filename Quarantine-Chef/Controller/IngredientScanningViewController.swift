//
//  ViewController.swift
//  Recipes-Swift
//
//  Created by Mohammed Ibrahim on 2019-12-27.
//  Copyright © 2019 Mohammed Ibrahim. All rights reserved.
//

import UIKit

class IngredientScanningViewController: CameraViewController {
    
    // MARK: - Outlets
    var ingredientsLabel: UILabel!
    var ingredientsCollectionView: UICollectionView!
    var basketCollectionView: UICollectionView!
    var finishButton: UIButton!
    var exitButton: UIButton!
    var impactGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    // MARK: - Variables
    // Boolean value on whether or not an ingredient was just added to the basket
    // Updated by delegate methods
    var justAdded: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    // MARK: - Change Status Bar to White
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Setup Views
    /// Setups constraints and relavent design aspects
    func setupViews() {
        
        // Exit Button
        exitButton = UIButton(frame: .zero)
        
        exitButton.backgroundColor = UIColor.white
        exitButton.tintColor = UIColor.black
        exitButton.titleLabel?.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        exitButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        exitButton.layer.cornerRadius = 8
        
        exitButton.addTarget(self, action: #selector(dismissScanner), for: .touchUpInside)

        exitButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(exitButton)
        
        exitButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        exitButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        // Finish button
        finishButton = UIButton(frame: .zero)
        
        finishButton.backgroundColor = UIColor.black
        finishButton.titleLabel?.textColor = .white
        finishButton.titleLabel?.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        finishButton.setTitle("Continue", for: .normal)
        finishButton.layer.cornerRadius = 8
        
        finishButton.addTarget(self, action: #selector(goToRecipes), for: .touchUpInside)
        finishButton.disable()
        
        finishButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(finishButton)
        
        finishButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        finishButton.rightAnchor.constraint(equalTo: self.exitButton.leftAnchor, constant: -10).isActive = true
        finishButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        finishButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        // Ingredients Collection View
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        ingredientsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        ingredientsCollectionView.backgroundColor = .clear
        
        ingredientsCollectionView.register(UINib(nibName: "IngredientCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ingredientCell")
        
        ingredientsCollectionView.dataSource = self
        ingredientsCollectionView.delegate = self
        
        ingredientsCollectionView.tag = 0
        
        ingredientsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(ingredientsCollectionView)
        
        
        // Constraints for Ingredients Collection View
        ingredientsCollectionView.bottomAnchor.constraint(equalTo: finishButton.topAnchor, constant: -20).isActive = true
        ingredientsCollectionView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        ingredientsCollectionView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        ingredientsCollectionView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        ingredientsCollectionView.showsHorizontalScrollIndicator = false
        ingredientsCollectionView.showsVerticalScrollIndicator = false
        ingredientsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        
        // Ingredients Label
        ingredientsLabel = UILabel(frame: .zero)
        ingredientsLabel.text = "Ingredients"
        ingredientsLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        ingredientsLabel.textColor = UIColor.white
        
        
        // Ingredients Label Constraints
        ingredientsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(ingredientsLabel)
        
        ingredientsLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        ingredientsLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        ingredientsLabel.widthAnchor.constraint(equalToConstant: 95).isActive = true
        ingredientsLabel.heightAnchor.constraint(equalToConstant: 37).isActive = true
        
        ingredientsLabel.fadeOut()
        
        
        // Basket Collection View
        let layout2 = UICollectionViewFlowLayout()
        layout2.scrollDirection = .horizontal
        
        basketCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout2)
        basketCollectionView.backgroundColor = .clear
        
        basketCollectionView.register(UINib(nibName: "BasketCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "basketCell")

        basketCollectionView.dataSource = self
        basketCollectionView.delegate = self

        basketCollectionView.tag = 1

        basketCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(basketCollectionView)

        // Constraints for Basket Collection View
        basketCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        basketCollectionView.leftAnchor.constraint(equalTo: self.ingredientsLabel.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        basketCollectionView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        basketCollectionView.heightAnchor.constraint(equalToConstant: 37).isActive = true

        basketCollectionView.showsHorizontalScrollIndicator = false
        basketCollectionView.showsVerticalScrollIndicator = false
        basketCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    /// Method to enable or disable relevant buttons depending on state of user's basket
    func enableDisableContinueButton() {
        if Ingredients.sharedInstance.basket.count == 0 {
            finishButton.disable()
            ingredientsLabel.fadeOut()
        } else {
            finishButton.enable()
            ingredientsLabel.fadeIn()
        }
    }
    
    // MARK: - Prediction
    /// Use latest frame and send it to the Clarifai API. Once predictions are returned, reload collection view to populate with those predictions (results).
    override func captureInput() {
        if let image = self.currentFrame {
            Ingredients.sharedInstance.predictFood(fromImage: image) { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.ingredientsCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
    // MARK: - Segues
    /// Go to recipes page
    @objc func goToRecipes() {
        self.performSegue(withIdentifier: "goToRecipes", sender: self)
        
        // Stop timer and API requests from shooting while in the Recipes page
        self.stop()
    }
    
    /// Dismiss scanning page and go back home
    @objc func dismissScanner() {
        self.navigationController?.popViewController(animated: true)
        
        Ingredients.sharedInstance.clearBasketAndPredictions()
        
        ingredientsCollectionView.reloadData()
        basketCollectionView.reloadData()
        
        // Stop timer and API requests from shooting while in the Recipes page
        self.stop()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension IngredientScanningViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView.tag == 0 ? Ingredients.sharedInstance.searchResults.count : Ingredients.sharedInstance.basket.count

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Collection View (tag 0) -> Bottom collection view with search results
        // Other collection view (else) -> Top collection view with current ingredients in basket
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ingredientCell", for: indexPath) as! IngredientCollectionViewCell
            cell.delegate = self
            cell.ingredient = Ingredients.sharedInstance.searchResults[indexPath.row]
            cell.updateLabel()
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "basketCell", for: indexPath) as! BasketCollectionViewCell
            cell.delegate = self
            cell.ingredient = Ingredients.sharedInstance.basket[indexPath.row]
            cell.updateLabel()
            
            cell.sizeToFit()
            
            // If this is the first cell, and the ingredient was just added (not deleted + updated)
            // Then add the green flash to indicate it was just added
            if self.justAdded && indexPath.row == 0 {
                cell.flashWhite()
            }
            
            self.justAdded = false
                        
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height

        return CGSize(width: 200, height: height)
    }
}

// MARK: - BasketCellDelegate
extension IngredientScanningViewController: BasketCellDelegate {
    /// Methods invoked from basket cells when a new ingredient is either added or removed
    func didRemoveIngredient() {
        self.justAdded = false
        
        basketCollectionView.reloadData()
        enableDisableContinueButton()
    }
    func didAddIngredient() {
        impactGenerator.impactOccurred()
        
        self.justAdded = true
        
        ingredientsCollectionView.reloadData()
        basketCollectionView.reloadData()
        enableDisableContinueButton()
    }
}
