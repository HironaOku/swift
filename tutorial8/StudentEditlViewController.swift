//
//  StudentEditViewController.swift
//
//  Created by Hirona Oku on 2021/04/27.
//
import Firebase
import FirebaseFirestoreSwift
import UIKit

class StudentEditViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationBarDelegate, UINavigationControllerDelegate {
   // @IBOutlet var titleLabel: UITextField!
    @IBOutlet var titleLabel: UITextField!
    @IBOutlet var yearLabel: UITextField!
    @IBOutlet var durationLabel: UITextField!
    
    @IBOutlet var studentPhoto: UIImageView!
    @IBOutlet var firstNameLabel: UILabel!
    @IBOutlet var familyNameLabel: UILabel!
    @IBOutlet var studentIDLabel: UILabel!
    //From lecture slide
    @IBAction func cameraButtonClicked(_ sender: UIButton) {
        
        //if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
        if UIImagePickerController.isSourceTypeAvailable(.camera)
         {
             print("Camera available")
             let imagePicker:UIImagePickerController = UIImagePickerController()
             imagePicker.delegate = self
             imagePicker.sourceType = UIImagePickerController.SourceType.camera
             imagePicker.allowsEditing = true
             
             self.present(imagePicker, animated: true, completion: nil)
         }
         else
         {
             print("No camera available")
         }
    }
    
     
     @IBAction func galleryButtonClicked(_ sender: UIButton) {
         if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
             print("Gallery available")
             
             let imagePicker:UIImagePickerController = UIImagePickerController()
             imagePicker.delegate = self
             imagePicker.sourceType = .photoLibrary;
             imagePicker.allowsEditing = false
             
             self.present(imagePicker, animated: true, completion: nil)
         }
     }

    
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
         {
            studentPhoto.image = image;
             dismiss(animated: true, completion: nil)
         }
     }
     
     func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         dismiss(animated: true, completion: nil)
     }
    //END From lecture slide 
        
        
    
    @IBAction func onSave(_ sender: Any) {
        (sender as! UIBarButtonItem).title = "Loading..."
        let givenName = titleLabel.text!
        if givenName.isEmpty  {
            firstNameLabel.textColor = UIColor.red
            (sender as! UIBarButtonItem).title = "Save"
            return
        }
        let familyName = yearLabel.text!
        if familyName.isEmpty  {
            familyNameLabel.textColor = UIColor.red
            (sender as! UIBarButtonItem).title = "Save"
            return
        }
        let studentIDs = durationLabel.text!
        if studentIDs.isEmpty  {
            studentIDLabel.textColor = UIColor.red
            (sender as! UIBarButtonItem).title = "Save"
            return
        }

        guard let studentID = Int32(durationLabel.text!) else {
            durationLabel.textColor = UIColor.red
            return
        }

            let db = Firestore.firestore()

        
        student!.family_name = familyName
        student!.given_name = givenName
        student!.studentID = studentID
        //student!.duration = Float(durationLabel.text!)! //good code would check this is a float
            do
            {
                //update the database (code from lectures)
                try db.collection("students").document(student!.id!).setData(from: student!){ err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                        
                        (sender as! UIBarButtonItem).title = "Save"
                        //this code triggers the unwind segue manually
                        self.performSegue(withIdentifier: "saveSegue", sender: sender)
//
//                        //alart
//                        let alert = UIAlertController(title: nil, message:nil, preferredStyle: .alert)
//                        alert.title = "Saved"
//                        alert.message = givenName + " " + familyName + "is saved successfully"
//
//                        //create alart button
//                        alert.addAction(UIAlertAction(
//                            title: "OK",
//                            style: .default,
//                            handler: nil
//                            )
//                        )
//                        self.present(
//                            alert,
//                            animated: true, completion: {
//
//                            })
                        
                    }
                }
            } catch { print("Error updating document \(error)") } //note "error" is a magic variable
    }
    
    //tutorial week9 Pass Data Between the Views
    var student : Student?
    var studentIndex : Int? //used much later in tutorial
    //End tutorial week9 Pass Data Between the Views
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Pass Data Between the Views
        if let displayStudent = student
        {
         self.navigationItem.title = displayStudent.given_name +  displayStudent.family_name//this awesome line sets the page title
            titleLabel.text = displayStudent.given_name
            yearLabel.text = displayStudent.family_name
            durationLabel.text = String(displayStudent.studentID)
            //durationLabel.text = String(displayStudent.duration)
        }
        //END tutorial week9 Pass Data Between the Views
        
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
