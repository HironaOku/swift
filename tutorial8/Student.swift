//
//
//  Created by Hirona Oku on 2021/04/27.
//

import Foundation

//Data Structure for a Row
public struct Student : Codable
{
    var id:String?
    var family_name:String
    var given_name:String
    var studentID:Int32
    var grade = [String:[String: String?]]()
}
//4 End
