//
//  ContactDetailViewController.swift
//  Contacts
//
//  Created by Anil Kumar on 19/11/19.
//  Copyright © 2019 Anil Kumar. All rights reserved.
//

import UIKit


class ContactDetailViewController: UIViewController {
    
    @IBOutlet weak var contactImageViewTopConstraint: NSLayoutConstraint?
    @IBOutlet weak var contactImageViewHeight: NSLayoutConstraint?
    @IBOutlet weak var contentScrollView: UIScrollView?
    @IBOutlet weak var contactImageView: UIImageView?
    @IBOutlet weak var contactNameLabel: UILabel?
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var contactAttributesTableView: UITableView? {
        didSet {
            contactAttributesTableView?.tableFooterView = UIView(frame: .zero)
        }
    }
    
    
    @IBAction func favouriteSelected(_ sender: Any) {
        
        contactDetailViewModel?.toggleFavorite()
        setFavoriteButtonImage()
       
    }
    
    
    var contactDetailViewModel: ContactDetailViewModel? {
        didSet {
            contactDetailViewModel?.delegate = self
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == ViewControllerSegue.EditContactViewSegue {
            let navigationViewController = segue.destination as? UINavigationController
            (navigationViewController?.topViewController as? CreateEditContactViewController)?.createEditContactViewModel = CreateEditContactViewModel(contactDetailViewModel?.contactDetail?.id)
        }
        
    }
    
    
}


extension ContactDetailViewController:UIScrollViewDelegate {
    
    func bindUI()  {
        
        guard let contactDetailVM = contactDetailViewModel else {
            return
        }
        
        contactNameLabel?.text = contactDetailVM.contactDetail?.firstName
        
        setFavoriteButtonImage()
        
        contactImageView?.drawRoundCorner(withRadius: (contactImageViewHeight?.constant ?? 100)/2)
        
        contactDetailVM.download(url: contactDetailVM.getProfilePicUrl() , completionHandler: { (data) in
            DispatchQueue.main.async {
                self.contactImageView?.image = UIImage(data: data)
            }
        })
        
    }
    
    func setFavoriteButtonImage() {
        
        if contactDetailViewModel?.contactDetail?.favorite == true {
            favoriteButton.setImage(#imageLiteral(resourceName: "favourite_button_selected.png"), for: .normal)
        } else {
            favoriteButton.setImage(#imageLiteral(resourceName: "favourite_button.png"), for: .normal)
        }
        
    }
}

extension ContactDetailViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension ContactDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactDetailViewModel?.contactTableData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactDetailTableViewCell.reuseIdentifier, for: indexPath) as? ContactDetailTableViewCell
        
        cell?.contactAttribute = contactDetailViewModel?.getContactAttribute(atIndex: indexPath.row)
        
        return cell!
        
    }
    
}


extension ContactDetailViewController: ContactDetailViewModelDelegate {
    
    func updateTableData() {
        bindUI()
        contactAttributesTableView?.reloadData()
    }
    
}

extension ContactDetailViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == contentScrollView{
            
            let offsetY = scrollView.contentOffset.y
            
            let topMargin = 10 < 50-(offsetY/4) ? 50-(offsetY/4) : 10
            
            let fontSize = 15 + (0 < 15-(offsetY/(200/15)) ? 15-(offsetY/(200/15)) : 0)
            let top = 50 < topMargin ? 50 : topMargin
            
            contactImageViewTopConstraint?.constant = top
            contactNameLabel?.font = contactNameLabel?.font.withSize(fontSize)
            let valueForHeight = top + 50
            
            contactImageViewHeight?.constant = valueForHeight
            contactImageView?.drawRoundCorner(withRadius: valueForHeight/2)
        }
    }
    
}
