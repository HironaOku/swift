//
//  MovieUITableViewController.swift
//
//  Created by Hirona Oku on 2021/04/27.
//

import UIKit
//Linking the UITableViewController to a Dataset
import Firebase
import FirebaseFirestoreSwift


class StudentUITableViewController: UITableViewController
{
    // Creating Unwind Segues
    @IBAction func unwindToStudentList(sender: UIStoryboardSegue)
    {
        //we could reload from db, but lets just trust the local movie object
        if let detailScreen = sender.source as? StudentDetailViewController
        {
            students[detailScreen.studentIndex!] = detailScreen.student!
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var remove: UIBarButtonItem!
    @IBAction func removeStudent(_ sender: Any) {
        print("remove student!!!!")
    }
    //    //------------------serch bar from apple developper
//
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet var table: UITableView!
    //@IBOutlet weak var spinner: UIActivityIndicatorView!
//
//    func setupSearchBar(){
//        search.delegate = self
//    }
//
//    var items = [Student]()
//    var currentItems = [Student]()
//
//
//    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
//    }
//    //  call this if searched
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        guard !searchText.isEmpty else {
//            currentItems = items
//            table.reloadData()
//            return
//        }
//        var studentid = String(items.studentID)
//        currentItems = items.filter({ item -> Bool in
//            studentid.contains(searchText)
//        })
//        table.reloadData()
//    }
//
//    //end------------------serch bar


    
    
    @IBAction func unwindToStudentListWithCancel(sender: UIStoryboardSegue)
    {
        //we could reload from db, but lets just trust the local movie object
        if let detailScreen = sender.source as? StudentDetailViewController
        {
            students[detailScreen.studentIndex!] = detailScreen.student!
            tableView.reloadData()
        }
    }
    
    //END Creating Unwind Segues
    var students = [Student]()
    override func viewDidLoad() {
    super.viewDidLoad()

        
        //Linking the UITableViewController to a Dataset
        let db = Firestore.firestore()
                let studentCollection = db.collection("students")
                studentCollection.getDocuments() { (result, err) in
                    if let err = err
                    {
                        print("Error getting documents: \(err)")
                    }
                    else
                    {
                        for document in result!.documents
                        {
                            let conversionResult = Result
                            {
                                try document.data(as: Student.self)
                            }
                            switch conversionResult
                            {
                                case .success(let convertedDoc):
                                    if var student = convertedDoc
                                    {
                                        // A `Student` value was successfully initialized from the DocumentSnapshot.
                                        student.id = document.documentID
                                        print("Student: \(student)")
                                        
                                        //NOTE THE ADDITION OF THIS LINE
                                        self.students.append(student)
                                    }
                                    else
                                    {
                                        // A nil value was successfully initialized from the DocumentSnapshot,
                                        // or the DocumentSnapshot was nil.
                                        print("Document does not exist")
                                    }
                                case .failure(let error):
                                    // A `Student` value could not be initialized from the DocumentSnapshot.
                                    print("Error decoding students: \(error)")
                            }
                        }
                        
                        //NOTE THE ADDITION OF THIS LINE
                        self.tableView.reloadData()
                    }
                }//End //Linking the UITableViewController to a Dataset
    
    }//End viewDidLoad

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        tableView.reloadData()
        
        //Linking the UITableViewController to a Dataset
        let db = Firestore.firestore()
                let studentCollection = db.collection("students")
                studentCollection.getDocuments() { (result, err) in
                    if let err = err
                    {
                        print("Error getting documents: \(err)")
                    }
                    else
                    {
                        self.students.removeAll()
                        for document in result!.documents
                        {
                            let conversionResult = Result
                            {
                                try document.data(as: Student.self)
                            }
                            switch conversionResult
                            {
                                case .success(let convertedDoc):
                                    if var student = convertedDoc
                                    {
                                        // A `Student` value was successfully initialized from the DocumentSnapshot.
                                        student.id = document.documentID
                                        print("Student: \(student)")
                                        
                                        //NOTE THE ADDITION OF THIS LINE
                                        self.students.append(student)
                                    }
                                    else
                                    {
                                        // A nil value was successfully initialized from the DocumentSnapshot,
                                        // or the DocumentSnapshot was nil.
                                        print("Document does not exist")
                                    }
                                case .failure(let error):
                                    // A `Student` value could not be initialized from the DocumentSnapshot.
                                    print("Error decoding students: \(error)")
                            }
                        }
                        
                        //NOTE THE ADDITION OF THIS LINE
                        self.tableView.reloadData()
                    }
                }//End // Linking the UITableViewController to a Dataset
    }
    // MARK: - Table view data source

    override func numberOfSections(in Int: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        // Linking the UITableViewController to a Dataset
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // Linking the UITableViewController to a Dataset
        return students.count
    }

    //Linking the UITableViewController to a Dataset
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentUITableViewCell", for: indexPath)

        //get the Student for this row
        let student = students[indexPath.row]

        //down-cast the cell from UITableViewCell to our cell class StudentUITableViewCell
        //note, this could fail, so we use an if let.
        if let studentCell = cell as? StudentUITableViewCell
        {
            //populate the cell
             studentCell.titleLabel.text = student.given_name + " " + student.family_name
            studentCell.subTitleLabel.text = String(student.studentID)
        }

        return cell
    }
    //END Linking the UITableViewController to a Dataset
    
    // Pass Data Between the Views
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        // is this the segue to the details screen? (in more complex apps, there is more than one segue per screen)
        if segue.identifier == "goToStudentDetail"
        {
              //down-cast from UIViewController to DetailViewController (this could fail if we didn’t link things up properly)
              guard let detailViewController = segue.destination as? StudentDetailViewController else
              {
                  fatalError("Unexpected destination: \(segue.destination)")
              }

              //down-cast from UITableViewCell to StudentUITableViewCell (this could fail if we didn’t link things up properly)
              guard let selectedStudentCell = sender as? StudentUITableViewCell else
              {
                  fatalError("Unexpected sender: \( String(describing: sender))")
              }

              //get the number of the row that was pressed (this could fail if the cell wasn’t in the table but we know it is)
              guard let indexPath = tableView.indexPath(for: selectedStudentCell) else
              {
                  fatalError("The selected cell is not being displayed by the table")
              }

              //work out which student it is using the row number
              let selectedStudent = students[indexPath.row]

              //send it to the details screen
              detailViewController.student = selectedStudent
              detailViewController.studentIndex = indexPath.row
        }
    }//END Pass Data Between the Views
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
