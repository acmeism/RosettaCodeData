import Foundation

let jsonString = "{ \"foo\": 1, \"bar\": [10, \"apples\"] }"
if let jsonData = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {
  if let jsonObject : AnyObject = NSJSONSerialization.JSONObjectWithData(jsonData, options: .AllowFragments, error: nil) {
    println("NSDictionary: \(jsonObject)")
  }
}

let obj = [
  "foo": [1, "Orange"],
  "bar": 1
]

if let objData = NSJSONSerialization.dataWithJSONObject(obj, options: .PrettyPrinted, error: nil) {
  if let jsonString2 = NSString(data: objData, encoding: NSUTF8StringEncoding) {
    println("JSON: \(jsonString2)")
  }
}
