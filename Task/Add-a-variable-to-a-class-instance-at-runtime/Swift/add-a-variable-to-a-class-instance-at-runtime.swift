import Foundation

let fooKey = UnsafeMutablePointer<UInt8>.alloc(1)

class MyClass { }
let e = MyClass()

// set
objc_setAssociatedObject(e, fooKey, 1, .OBJC_ASSOCIATION_RETAIN)

// get
if let associatedObject = objc_getAssociatedObject(e, fooKey) {
  print("associated object: \(associatedObject)")
} else {
  print("no associated object")
}
