//
//
//  StudentAddViewController.swift
//
//  Created by Hirona Oku on 2021/05/19.
//

import Firebase
import FirebaseFirestoreSwift
import UIKit

class StudentAddViewController:
    UIViewController,UIImagePickerControllerDelegate,UINavigationBarDelegate, UINavigationControllerDelegate {
    //label(form)
    @IBOutlet var FirstName: UITextField!
    @IBOutlet var FamilyName: UITextField!
    @IBOutlet var StudentID: UITextField!
    
    var student : Student?
    
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
        let givenName = FirstName.text!
        if givenName.isEmpty  {
            firstNameLabel.textColor = UIColor.red
            (sender as! UIBarButtonItem).title = "Save"
            return
        }
        let familyName = FamilyName.text!
        if familyName.isEmpty  {
            familyNameLabel.textColor = UIColor.red
            (sender as! UIBarButtonItem).title = "Save"
            return
        }
        let studentIDs = StudentID.text!
        if studentIDs.isEmpty  {
            studentIDLabel.textColor = UIColor.red
            (sender as! UIBarButtonItem).title = "Save"
            return
        }

        guard let newstudentID = Int32(StudentID.text!) else {
            studentIDLabel.textColor = UIColor.red
            return
        }

        let studentData = Student(family_name: familyName, given_name: givenName, studentID: newstudentID)
        let db = Firestore.firestore()
        let studentCollection = db.collection("students")

            do
            {
                //adding the database (code from lectures)
                try studentCollection.addDocument(from: studentData, completion: {(err) in
                    if let err = err {
                        print("Error updating document: \(err)")
                        
                    } else {
                        print("Document successfully saved")
                        (sender as! UIBarButtonItem).title = "Save"
                        self.performSegue(withIdentifier: "saveAddsegue", sender: sender)
                    }
                })
                } catch { print("Error updating document \(error)") } //note "error" is a magic variable

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

}

