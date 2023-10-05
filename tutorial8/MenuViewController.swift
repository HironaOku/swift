//
//  ViewController.swift
//
//  Created by Hirona Oku on 2021/04/26.
//

import UIKit

//3 Adding a Database Connection Handle
import Firebase
import FirebaseFirestoreSwift
//3 end

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //4 Adding a Database Connection Handle
        let db = Firestore.firestore()
        
        //Getting Data
        let studentCollection = db.collection("students")
        studentCollection.getDocuments() { (result, err) in
          //check for server error
          if let err = err
          {
              print("Error getting documents: \(err)")
          }
          else
          {
              //loop through the results
              for document in result!.documents
              {
                  //attempt to convert to Movie object
                  let conversionResult = Result
                  {
                      try document.data(as: Student.self)
                  }

                  //check if conversionResult is success or failure (i.e. was an exception/error thrown?
                  switch conversionResult
                  {
                      //no problems (but could still be nil)
                      case .success(let convertedDoc):
                          if let student = convertedDoc
                          {
                              // A `Movie` value was successfully initialized from the DocumentSnapshot.
                              print("Student: \(student)")
                          }
                          else
                          {
                              // A nil value was successfully initialized from the DocumentSnapshot,
                              // or the DocumentSnapshot was nil.
                              print("Document does not exist")
                          }
                      case .failure(let error):
                          // A `Movie` value could not be initialized from the DocumentSnapshot.
                          print("Error decoding student: \(error)")
                  }
              }
          }
        }
        //7 END Getting Data
        
    }


}

