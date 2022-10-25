//
//  ViewController.swift
//  GympassChallenge
//
//  Created by Caio Berkley on 25/10/22.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Variables & Outlet
    var result = [[Int]]()
    
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var userInputTextField: UITextField!
    @IBOutlet weak var outputTextView: UITextView!
    @IBOutlet weak var clearResultButton: UIButton!
    
    // MARK: Lifecycle & Engineering
    override func viewDidLoad() {
        super.viewDidLoad()
  
        // MARK: Keyboard engineering
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    // MARK: Functions
    func subsets(_ nums: [Int]) -> [[Int]] {
        if nums.isEmpty {
            return result
        }
        result.append([])
        dfs(nums)
        return result
    }
        
    func dfs(_ nums: [Int]) {
        if nums.count == 1 {
            result.append([nums.first!])
            return
        }
        dfs(nums.dropLast())
        result.forEach({
            result.append($0)
            result[result.count - 1].append(nums.last!)
        })
    }
    
    func clearLastResult(){
        userInputTextField.text = ""
        result = []
    }
    
    @objc func dismissImageView() {
        self.detailsImageView.isHidden = true
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -290
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0
    }
    
    // MARK: Actions
    @IBAction func resultButtonTapped(_ sender: Any) {
        guard let userDigits = userInputTextField.text else { return }
        let digits = userDigits.compactMap{Int(String($0))}
        let unique = digits.removingDuplicates()
        
        outputTextView.text = "The subsets are: \(subsets(unique))"
        clearResultButton.isHidden = false
        clearLastResult()
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        outputTextView.text = "The subsets will appear below here."
        clearResultButton.isHidden = true
        clearLastResult()
    }
    
    @IBAction func detailsButtonTapped(_ sender: Any) {
        if detailsImageView.isHidden == true {
            detailsImageView.isHidden = false
            detailsButton.setTitle("Click to close details", for: .normal)
        } else {
            detailsImageView.isHidden = true
            detailsButton.setTitle("Click here for details", for: .normal)
        }
    }
}

// MARK: To remove possible duplicate numbers that the user might enter.
extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

// MARK: To prevent the user from pasting texts into the number field.
extension UITextField {

    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
            return action == #selector(UIResponderStandardEditActions.cut) || action == #selector(UIResponderStandardEditActions.copy)
        }
}
