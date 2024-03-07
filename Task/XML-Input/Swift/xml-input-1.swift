import Foundation

let xmlString = """
<Students>
	<Student Name="April" Gender="F" DateOfBirth="1989-01-02" />
	<Student Name="Bob" Gender="M"  DateOfBirth="1990-03-04" />
	<Student Name="Chad" Gender="M"  DateOfBirth="1991-05-06" />
	<Student Name="Dave" Gender="M"  DateOfBirth="1992-07-08">
		<Pet Type="dog" Name="Rover" />
	</Student>
	<Student DateOfBirth="1993-09-10" Gender="F" Name="&#x00C9;mily" />
</Students>
"""
if let xmlData = xmlString.data(using: .utf8) {
	do {
		let doc = try XMLDocument(data: xmlData)
		print("Using XPath:")
		for node in try doc.nodes(forXPath: "/Students/Student/@Name") {
			guard let name = node.stringValue else { continue }
			print(name)
		}
		print("Using node walk")
		if let root = doc.rootElement() {
			for child in root.elements(forName: "Student") {
				guard let name = child.attribute(forName: "Name")?.stringValue else { continue }
				print(name)
			}
		}
	} catch {
		debugPrint(error)
	}
}
