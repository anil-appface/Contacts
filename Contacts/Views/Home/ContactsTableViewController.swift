//
//  ContactsTableViewController.swift
//  Contacts
//
//  Created by Anil Kumar on 19/11/19.
//  Copyright © 2019 Anil Kumar. All rights reserved.
//

import UIKit

class ContactsTableViewController: UITableViewController {
    
    
    var contactViewModel = ContactViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        contactViewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contactViewModel.fetchAllContacts()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return contactViewModel.allSections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return contactViewModel.contactsDictionary[contactViewModel.allSections[section]]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contactViewModel.allSections[section]
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.resuseIdentifier, for: indexPath) as? ContactTableViewCell
        
        cell?.contact = contactViewModel.getContactAt(section: indexPath.section, row: indexPath.row)
        
        return cell!
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return contactViewModel.allSections
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let contact = contactViewModel.getContactAt(section: indexPath.section, row: indexPath.row)
        
        performSegue(withIdentifier: ViewControllerSegue.ContactsDetailViewControllerSegue, sender: contact)
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
        
        let contactDetailViewController = segue.destination as? ContactDetailViewController
        contactDetailViewController?.contactDetailViewModel = ContactDetailViewModel((sender as? Contact)?.id)
        
     }
     
    
}


extension ContactsTableViewController: ContactViewModelDelegate {
    
    func updateContacts() {
        tableView.reloadData()
    }
    
}
