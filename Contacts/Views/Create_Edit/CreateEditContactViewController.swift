//
//  CreateEditContactViewController.swift
//  Contacts
//
//  Created by Anil Kumar on 19/11/19.
//  Copyright © 2019 Anil Kumar. All rights reserved.
//

import UIKit

class CreateEditContactViewController: UIViewController {
    
    @IBOutlet weak var attributeTableView: UITableView? {
        didSet {
            attributeTableView?.tableFooterView = UIView(frame: .zero)
        }
    }
    @IBOutlet weak var contactImageView: UIImageView?
    @IBOutlet weak var viewToBottomSpacingConstraint: NSLayoutConstraint?
    
    var createEditContactViewModel: CreateEditContactViewModel? {
        didSet {
            createEditContactViewModel?.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneSelected(_ sender: Any) {
        createEditContactViewModel?.updateOrCreateContact()
    }
    
    @IBAction func cameraSelected(_ sender: Any) {
    }
    
    @IBAction func dismissSelected(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension CreateEditContactViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return createEditContactViewModel?.contractAttribute.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CreateEditContactTableViewCell.reuseIdentifier, for: indexPath) as? CreateEditContactTableViewCell
        
        cell?.contactAttribute = createEditContactViewModel?.contractAttribute[indexPath.row]
        
        cell?.textFieldValueChange = { (cellType, value) in
            self.createEditContactViewModel?.updateContactDetailValue(cellType: cellType, value: value)
        }
        
        return cell!
    }
    
}

extension CreateEditContactViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}



extension CreateEditContactViewController: CreateEditContactViewModelDelegate {
    func updateTableData() {
        attributeTableView?.reloadData()
    }
    
    func errorCreatingUpdatingContact(error: String?) {
        showAlert(alertText: "Gojeck Contact", alertMessage: error ?? "Error!!")
    }
    
    func successCreatingUpdatingContact() {
        if let presenter = (presentingViewController as? UINavigationController)?.viewControllers.last as? ContactDetailViewController, let id = createEditContactViewModel?.contactDetail?.id {
            presenter.contactDetailViewModel?.fetchContact(forContactId: id)
        }
        navigationController?.dismiss(animated: true, completion: nil)
    }
}


extension CreateEditContactViewController {
    
    @objc func keyboardWillShow(_ notification: NSNotification){
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let height = keyboardSize.cgRectValue.height
        viewToBottomSpacingConstraint?.constant = height
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification){
        viewToBottomSpacingConstraint?.constant = 0
    }
}
