//
//  UnsubmittedAssignmentViewController.swift
//  MusicMaker
//
//  Created by Linh Bouniol on 11/6/18.
//  Copyright © 2018 Vuk. All rights reserved.
//

import UIKit

class UnsubmittedAssignmentViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AssignmentHeaderCell", for: indexPath) as! AssignmentHeaderTableViewCell
            
            cell.assignmentTitleLabel.text = "this is a test assignment"
            cell.dueDateLabel.text = "DEC 9"
            cell.dueTimeLabel.text = "8:00 PM"
            cell.instrumentLabel.text = "🎻"
            
            return cell
        default:
            fatalError("We forgot a case: \(indexPath.row)")
        }
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
