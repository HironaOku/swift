//
//  StudentDetailViewController.swift
//
//  Created by Hirona Oku on 2021/05/18.
//

import Firebase
import FirebaseFirestoreSwift
import UIKit

class StudentDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var FirstNameLabel: UILabel!
    @IBOutlet var FamilyNameLabel: UILabel!
    @IBOutlet var StudentIDLabel: UILabel!
    //tutorial week9 Pass Data Between the Views
    var student : Student?
    var weeks = [Week]()
    var week = [Week]()
    var studentIndex : Int? //used much later in tutorial
    var existingMark: Int = 0 //0-> no data 1-> there is but no mark 2-> there is mark
    var markStyle: String = ""
    var maxValue: Int? = 0
    var max_mark: Int = 0
    @IBOutlet var StudentDetailView: UITableView!
    
    
    // alert START---------------------------------
    @IBAction func dispAlert(_ sender: Any) {

        let actionSheet = UIAlertController(title: "Remove",
                                            message: "Are you sure? Remove This student information and results?",
                                            preferredStyle: UIAlertController.Style.actionSheet)

        // OK--------
        let action1 = UIAlertAction(title: "Remove this student", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) in
            self.remove((Any).self)
            print("Remove this student.......")
        })

        //Cancel-----
        let close = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: {
            (action: UIAlertAction!) in
            print("canceled")
        })

        actionSheet.addAction(action1)
        actionSheet.addAction(close)

        //disp Alert
        self.present(actionSheet, animated: true, completion: nil)
    }
    // END alert ---------------------------------
    //-------remove Student from lecture slide
    func remove(_ sender: Any) {
        
        
        
        let db = Firestore.firestore()
        db.collection("students").document(student!.id!).delete(){
            err in
            if let err = err{
                print("Error removing document: \(err)")
            } else {
                print("Document succcessfully removed!")
                //this code triggers the unwind segue manually
                self.performSegue(withIdentifier: "removedSegue", sender: sender)
            }
            
        }
        
    }
    //END-------remove Student

    //End tutorial week9 Pass Data Between the Views
    @IBAction func unwindToStudentDetailWithCancel(sender: UIStoryboardSegue)
    {
    }
    @IBAction func unwindToStudentDetailWithSaved(sender: UIStoryboardSegue)
    {

        //tutorial week9 Pass Data Between the Views
        if let displayStudent = student
        {
            
            //we could reload from db, but lets just trust the local movie object
            guard let source = sender.source as? StudentEditViewController  else { return }
            
            student?.family_name = source.student!.family_name
            student?.given_name = source.student!.given_name
            student?.studentID = source.student!.studentID
            
            self.navigationItem.title = source.student!.given_name + " " + source.student!.family_name//this awesome line sets the page title
            FirstNameLabel.text = source.student!.given_name
            FamilyNameLabel.text = source.student!.family_name
            StudentIDLabel.text = String(source.student!.studentID)
            //durationLabel.text = String(displayStudent.duration)
    
        }
        //END Pass Data Between the Views
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

            // Do any additional setup after loading the view.
            // Pass Data Between the Views
            if let displayStudent = student
            {
             self.navigationItem.title = displayStudent.given_name + " " + displayStudent.family_name//this awesome line sets the page title
                FirstNameLabel.text = displayStudent.given_name
                FamilyNameLabel.text = displayStudent.family_name
                StudentIDLabel.text = String(displayStudent.studentID)
                //durationLabel.text = String(displayStudent.duration)
            }
        
        //let db = Firestore.firestore()
        let db = Firestore.firestore()
        let weekCollection = db.collection("weeks")
        //let weekDocument = "week"+String(selectedWeek)
        
        weekCollection.getDocuments(){ (result, err) in
            if let err = err {
                print("Error getting document  : \(err)")
            } else {
                for document in result!.documents {
                let conversionResult = Result {
                    try document.data(as: Week.self)
                }

                    switch conversionResult {
                        case .success(let convertedDoc):
                            if let week = convertedDoc {
                                
                                // A `Student` value was successfully initialized from the DocumentSnapshot.
                                
                                print("Week: \(week)")
                                
                                //NOTE THE ADDITION OF THIS LINE
                                self.weeks.append(week)
                                
                                //there is existing mark
                                //self.NewMarkBtn.isEnabled = false
                                self.existingMark = 2//0-> no data 1-> there is but no mark 2-> there is mark
                                self.max_mark = Int(week.max)
                                self.StudentDetailView.reloadData()
                            } else {
                                // A nil value was successfully initialized from the DocumentSnapshot,
                                // or the DocumentSnapshot was nil.
                                print("Never marked on selected week")
                                
                                //No mark on selected week
                                //self.NewMarkBtn.isEnabled = true
                                self.existingMark = 0//0-> no data 1-> there is but no mark 2-> there is mark
                                
                                
                            }
                        case .failure(let error):
                            // A `Student` value could not be initialized from the DocumentSnapshot.
                            print("Had marked however couldnt initialized (no mark) \(error)")
                            //No mark on selected week
                            //self.NewMarkBtn.isEnabled = true
                            self.existingMark = 1 //0-> no data 1-> there is but no mark 2-> there is mark
                    }
                }
                //self.StudentDetailTableView.reloadData()
                
            }

        }//End //tutorial week9 Linking the UITableViewController to a Dataset
            //END tutorial week9 Pass Data Between the Views
        

    }//End viewDidLoad
//    override func numberOfSections(in Int: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        //tutorial week9 Linking the UITableViewController to a Dataset
//        return 1
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = StudentDetailView.dequeueReusableCell(withIdentifier: "StudentDetailTableViewCell", for: indexPath)
        
        let week = weeks[indexPath.row]
        
        if let weekCell = cell as? StudentDetailTableViewCell
        {
            //populate the cell
            let weeknun = week.week_name
            weekCell.weekLabel.text = weeknun
            weekCell.markTypeLabel.text = week.mark_type
            
            let mark = student?.grade[weeknun ?? "0"]
            if(mark == nil){
                weekCell.gradeLabel.text = "0 / " + String(max_mark)
                //weekCell.gradeLabel.text = "0"
            } else{
                weekCell.gradeLabel.text = mark!["mark"]!! + " / " + String(max_mark)
                //weekCell.Score.text =  mark!["mark"]!!
            }
            weekCell.markTypeLabel.text = week.mark_type
        }

        return cell
    }
    //tutorial week9 Pass Data Between the Views
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        // is this the segue to the details screen? (in more complex apps, there is more than one segue per screen)
        if segue.identifier == "goToStudentEdit"
        {
            if let nextScreen = segue.destination as? StudentEditViewController{
                nextScreen.student = student
                nextScreen.studentIndex = studentIndex
            }

        }
    }//END tutorial week9 Pass Data Between the Views

    /*
    // MARK: - Navigation

}
