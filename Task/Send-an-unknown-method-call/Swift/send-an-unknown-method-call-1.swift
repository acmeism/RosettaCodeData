import Foundation

class MyUglyClass: NSObject {
  @objc
  func myUglyFunction() {
    print("called myUglyFunction")
  }
}

let someObject: NSObject = MyUglyClass()

someObject.perform(NSSelectorFromString("myUglyFunction"))
