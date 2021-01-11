import Foundation
import GoogleUtilities_UserDefaults
//import FirebaseAuth


struct MyApplication {
  static func main() {
    // ActionCodeInfo()
    let ud = GULUserDefaults.standard()
    print("\(ud)")
    print(Date())
  }
}

MyApplication.main()
