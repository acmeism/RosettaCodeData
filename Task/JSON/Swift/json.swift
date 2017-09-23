import Foundation

let jsonString = "{ \"foo\": 1, \"bar\": [10, \"apples\"] }"
if let jsonData = jsonString.data(using: .utf8) {
	if let jsonObject: Any = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) {
		print("Dictionary: \(jsonObject)")
	}
}

let obj = [
	"foo": [1, "Orange"],
	"bar": 1
] as [String : Any]

if let objData = try? JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted) {
	if let jsonString2 = String(data: objData, encoding: .utf8) {
		print("JSON: \(jsonString2)")
	}
}
