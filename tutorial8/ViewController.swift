//
//  ViewController.swift
//  tutorial8
//
//  Created by Hirona Oku on 2021/04/26.
//

import UIKit

//3 tutorial week9 Adding a Database Connection Handle
import Firebase
import FirebaseFirestoreSwift
//3 end

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //4 tutorial week9 Adding a Database Connection Handle
        let db = Firestore.firestore()
        
//        //6 tutorial week9 Adding a Row (the dumb way)
//        let movieCollection = db.collection("movies")
//        let matrix = Student(title: "The Matrix", year: 1999, duration: 150)
//        do {
//            try movieCollection.addDocument(from: matrix, completion: { (err) in
//                if let err = err {
//                    print("Error adding document: \(err)")
//                } else {
//                    print("Successfully created movie")
//                }
//            })
//        } catch let error {
//            print("Error writing city to Firestore: \(error)")
//        }
//        //6 End  week9 Adding a Row (the dumb way)
        
        //7 tutorial week9 Getting Data
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
        //7 END tutorial week9 Getting Data
        
    }


}

