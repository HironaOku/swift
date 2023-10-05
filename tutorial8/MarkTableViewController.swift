//
//  MarkUITableViewController.swift
//
//  Created by Hirona Oku on 2021/05/20.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class MarkTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, InputTextTableCellDelegate{
    
    private var myTextField: UITextField!
    let weekPicker = UIPickerView()
    let weekdata =  ["Week1", "Week2", "Week3", "Week4", "Week5", "Week6", "Week7", "Week8", "Week9", "Week10", "Week11", "Week12"]
   
    @IBOutlet var button: UIButton!
    @IBOutlet weak var markTableView: UITableView!
    @IBOutlet var weelField: UITextField!
    @IBOutlet var NewMarkBtn: UIButton!
    
    @IBOutlet var editButton: UIButton!
    @IBOutlet var chkNumber: UIStepper!
    @IBOutlet var maxValueField: UITextField!
    @IBOutlet var maxValueLabel: UILabel!
    
    @IBOutlet var SavedLabel: UILabel!
    @IBOutlet var createSchemaBtn: UIButton!
    @IBOutlet var ErrorLabel: UILabel!
    
    //@IBOutlet var maxValueLabel: UILabel!
    //@IBOutlet var maxValueField: UITextField!
    //@IBOutlet var chkNumber: UIStepper!
    
    var students = [Student]()
    var weeks = [Week]()
    var max_mark: Int = 0
    var selectedWeek: Int = 0
    var existingMark: Int = 0 //0-> no data 1-> there is but no mark 2-> there is mark
    var markStyle: String = ""
    var maxValue: Int? = 0
    var editMode: Bool = false

    @IBAction func newMarkSelect(_ sender: Any) {
        print("clicked new mark")
        // alert START---------------------------------
       

            let actionSheet = UIAlertController(title: "New mark",
                                                message: "Select marking style",
                                                preferredStyle: UIAlertController.Style.actionSheet)

            // Score--------
            let action1 = UIAlertAction(title: "Score", style: UIAlertAction.Style.default, handler: {
                (action: UIAlertAction!) in
                //self.remove((Any).self)
                print("Slected Score marking scheme")
                self.markStyle = "score"
                
                self.maxValueLabel.isHidden = false
                self.maxValueField.isHidden = false
                self.maxValueLabel.text = "Please enter max score."
                
                self.markTableView.reloadData()
                
            })
            // grade HD/DN/CR/PP--------
            let action2 = UIAlertAction(title: "Grade HD/DN/CR/PP", style: UIAlertAction.Style.default, handler: {
                (action: UIAlertAction!) in
                //self.remove((Any).self)
                print("Slected Grade HD/DN/CR/PP marking scheme")
                self.markStyle = "gradeHD"
                self.markTableView.reloadData()
            })
        
            // grade A/B/C/D--------
            let action3 = UIAlertAction(title: "Grade A/B/C/D", style: UIAlertAction.Style.default, handler: {
                (action: UIAlertAction!) in
                //self.remove((Any).self)
                print("Slected Grade A/B/C/D marking scheme")
                self.markStyle = "gradeABC"
                self.markTableView.reloadData()
            })
        
            // Check point--------
            let action4 = UIAlertAction(title: "Check box", style: UIAlertAction.Style.default, handler: {
                (action: UIAlertAction!) in
                //self.remove((Any).self)
                print("Check box")
                self.markStyle = "chkBox"
                self.markTableView.reloadData()
            })
            // Check point attendance--------
            let action5 = UIAlertAction(title: "Attendance", style: UIAlertAction.Style.default, handler: {
                (action: UIAlertAction!) in
                //self.remove((Any).self)
                print("Attendance")
                self.markStyle = "attendance"
                self.markTableView.reloadData()
            })

            //Cancel-----
            let close = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: {
                (action: UIAlertAction!) in
                print("canceled")
                self.markStyle = ""
            })

        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(action3)
        actionSheet.addAction(action4)
        actionSheet.addAction(action5)
            actionSheet.addAction(close)

            //disp Alert
            self.present(actionSheet, animated: true, completion: nil)
        
            // END alert ---------------------------------
    }//END newMarkSelection
    
    @IBAction func clickCreateMarkingBtn(_ sender: Any) {
        
        
        
        createSchemaBtn.isHidden = true
        
    }//END clickCreateMarkingBtn
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ErrorLabel.isHidden=true
        SavedLabel.isHidden=true
        createSchemaBtn.isHidden = true
        maxValueField.keyboardType = UIKeyboardType.numberPad
        //set display
        
        NewMarkBtn.isEnabled = false
        markTableView.dataSource = self
        markTableView.delegate = self
        maxValueLabel.isHidden = true
        maxValueField.isHidden = true
        chkNumber.isHidden = true
        editButton.isHidden = true
        //for picker
        weekPicker.delegate = self
        weekPicker.dataSource = self
        weelField.inputView = weekPicker
    

        
        //Linking the UITableViewController to a Dataset
        let db = Firestore.firestore()
        let studentCollection = db.collection("students")
        studentCollection.getDocuments() { (result, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in result!.documents {
                    let conversionResult = Result {
                        try document.data(as: Student.self)
                    }
                    switch conversionResult {
                        case .success(let convertedDoc):
                            if var student = convertedDoc {
                                // A `Student` value was successfully initialized from the DocumentSnapshot.
                                student.id = document.documentID
                                print("Student: \(student)")
                                
                                //NOTE THE ADDITION OF THIS LINE
                                self.students.append(student)
                            } else {
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
                self.markTableView.reloadData()
            }
        }//End Linking the UITableViewController to a Dataset
        
     
    }//END viewDidLoad()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = markTableView.dequeueReusableCell(withIdentifier: "MarkTableViewCell", for: indexPath)
        
        

        //get the Student for this row
        let student = students[indexPath.row]
        
        //down-cast the cell from UITableViewCell to our cell class MarkTableViewCell
        //note, this could fail, so we use an if let.
        if let studentCell = cell as? MarkTableViewCell
        {
            studentCell.button.isHidden = true
            studentCell.Score.tag = indexPath.row
            studentCell.Score.delegate = self
            studentCell.Score.keyboardType = UIKeyboardType.numberPad
            //populate the cell
            studentCell.FirstNameLabel.text = student.given_name
            
            studentCell.LastNameLabel.text = student.family_name
            studentCell.StudentIDLabel.text = String(student.studentID)
            
            studentCell.GradeLabel.isHidden = true
            studentCell.Score.isHidden = true
            //studentCell.GradeLabel.isHidden = true
            if(existingMark == 0){ //0-> no data 1-> there is but no mark 2-> there is mark

            } else if (existingMark == 1){
                
                
            } else if (existingMark == 2){
                studentCell.GradeLabel.isHidden = false
                
                let weekDocument = "week"+String(selectedWeek)
                let mark = student.grade[weekDocument]
                if(mark == nil){
                    studentCell.GradeLabel.text = "0 / " + String(max_mark)
                    studentCell.Score.text = "0"
                } else{
                    studentCell.GradeLabel.text = mark!["mark"]!! + " / " + String(max_mark)
                    studentCell.Score.text =  mark!["mark"]!!
                }
                editButton.isHidden = false
                if(editMode != false){
                    editButton.isHidden = true
                    
                    studentCell.GradeLabel.isHidden = true
                    studentCell.Score.isHidden = false
                    maxValueField.text=String(max_mark)
                    maxValueField.isHidden=false
                    maxValueLabel.isHidden=false
                    
                    
                }
                
                
                
            }
            
            if(markStyle == "score"){
                studentCell.Score.isHidden = false
                //createSchemaBtn.isHidden = false
                
                
            } else if(markStyle == "gradeHD"){
                
            } else if(markStyle == "gradeABC"){
                
            } else if(markStyle == "chkBox"){
                
            } else if(markStyle == "attendance"){
                
            }
        }
        
        return cell
    }

    @IBAction func EditClicked(_ sender: Any) {
        
        editMode = true
        self.markTableView.reloadData()
        
    }
    
}
extension MarkTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return weekdata.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return weekdata[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        weelField.text = weekdata[row]
        weelField.resignFirstResponder()
        print(String(row))
        selectedWeek = row + 1
        editMode = false
        maxValueField.isHidden=true
        maxValueLabel.isHidden=true
        //Linking the UITableViewController to a Dataset
        //let db = Firestore.firestore()
        let db = Firestore.firestore()
        let weekCollection = db.collection("weeks")
        let weekDocument = "week"+String(selectedWeek)
        
        weekCollection.document(weekDocument).getDocument { (result, err) in
            if let err = err {
                print("Error getting document  : \(err)")
            } else {
//
//                print("\(result!.documentID) => \(result!.data(as: Week.self))")
//                result!.documentID => result?.data()
//                for document in result {
                    let conversionResult = Result {
                        try result!.data(as: Week.self)
                    }
                    switch conversionResult {
                        case .success(let convertedDoc):
                            if let week = convertedDoc {
                                
                                // A `Student` value was successfully initialized from the DocumentSnapshot.
                                
                                print("Week: \(week)")
                                
                                //NOTE THE ADDITION OF THIS LINE
                                self.weeks.append(week)
                                
                                //there is existing mark
                                self.NewMarkBtn.isEnabled = false
                                self.existingMark = 2//0-> no data 1-> there is but no mark 2-> there is mark
                                self.max_mark = Int(week.max)
        
                            } else {
                                // A nil value was successfully initialized from the DocumentSnapshot,
                                // or the DocumentSnapshot was nil.
                                print("Never marked on selected week")
                                
                                //No mark on selected week
                                self.NewMarkBtn.isEnabled = true
                                self.existingMark = 0//0-> no data 1-> there is but no mark 2-> there is mark
                                
                                
                            }
                        case .failure(let error):
                            // A `Student` value could not be initialized from the DocumentSnapshot.
                            print("Had marked however couldnt initialized (no mark) \(error)")
                            //No mark on selected week
                            self.NewMarkBtn.isEnabled = true
                            self.existingMark = 1 //0-> no data 1-> there is but no mark 2-> there is mark
                    }
            //    }
                self.markTableView.reloadData()
                
            }

        }//End Linking the UITableViewController to a Dataset
        
    }
}

extension MarkTableViewController: UITextFieldDelegate {
    internal func textFieldShouldBeginEditing(_ scoreField: UITextField) {
 
        let maxValue1 = self.maxValueField.text!
        if maxValue1.isEmpty  {
            self.maxValueLabel.textColor = UIColor.red
            print("no max value")
            
        } else {
            self.markTableView.reloadData()
        }
        
    }
    
    internal func textFieldDidEndEditing(_ scoreField: UITextField) {
        print("entered max value")
        print(scoreField.tag, " -> ", scoreField.text as Any)
        let score = scoreField.text!
        print(score)
        //print("tag",Score.tag)

        let maxValue1 = self.maxValueField.text!
        if maxValue1.isEmpty  {
            self.maxValueLabel.textColor = UIColor.red
            print("no max value")
            self.ErrorLabel.isHidden=false
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) {_ in
                self.ErrorLabel.isHidden=true
            }
        } else {
            self.maxValue = Int(self.maxValueField.text!)!
            if (self.maxValue ?? 0 <= 100 && self.maxValue ?? 0 >= 0){
                //print(maxValue as String?)
            } else {
                self.maxValueLabel.text = "Max value should be 0~100"
                self.maxValueLabel.textColor = UIColor.red
                
                self.ErrorLabel.isHidden=false
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) {_ in
                    self.ErrorLabel.isHidden=true
                }
            }
            print(self.maxValue ?? 0)
            
            if(Int(score) ?? 0 == 0){
                print("nothing to do hehe")
            } else if(self.maxValue ?? 0 < Int(score) ?? 0){
                scoreField.textColor = UIColor.red
                
                self.ErrorLabel.isHidden=false
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) {_ in
                    self.ErrorLabel.isHidden=true
                }

                
                
            } else {
                scoreField.textColor = UIColor.black
                var student = students[scoreField.tag]
                let docID = student.id
                let db = Firestore.firestore()
                let week = "week" + String(selectedWeek)
                student.grade = [ week :[ "mark" : score, "mark_type" : markStyle]]
                
                
                do {
                    try db.collection("students").document(docID!).setData(
                        ["grade":student.grade], merge: true                                          ){ err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                            self.SavedLabel.isHidden = false
                            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) {_ in
                                self.SavedLabel.isHidden = true
                            }
                            
                        }
                    }
                } catch { print("Error updating document \(error)") }
                
                do {
                    try db.collection("weeks").document(week).setData(
                        ["mark_type": markStyle,
                         "max": self.maxValue ?? 0,
                         "week_name" : week], merge: true                                          ){ err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                            self.SavedLabel.isHidden = false
                            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) {_ in
                                
                            }
                            
                        }
                    }
                } catch { print("Error updating document \(error)") }
                //var id =
                
//                let db = Firestore.firestore()
//                let studentCollection = db.collection("students")
//                let week = "week" + String(selectedWeek)
//                studentCollection.document(students.id).updateData(
//                    ["grade":[week : score])
//                        { (err) in
//                        if let err = err {
//                        print("Error updating documents: \(err)")
//
//                        } else {
//                        print("Document updated!")
//
//                        }
//
//                        }

                
            }
            
            
        }
        //Int(self.maxValueField.text!)!

        
        //return true
        
    }
    func textFieldDidEndEditing(cell: MarkTableViewCell, value: NSString) -> () {
        let path = markTableView.indexPathForRow( at: cell.convert(cell.bounds.origin, to: markTableView))
        print("row = %d, value = %@", path!.row, value)
    }
}
