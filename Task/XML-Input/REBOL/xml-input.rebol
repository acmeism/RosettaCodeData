REBOL [
	Title: "XML Reading"
	URL: http://rosettacode.org/wiki/XML_Reading
]

xml: {
<Students>
  <Student Name="April" Gender="F" DateOfBirth="1989-01-02" />
  <Student Name="Bob" Gender="M"  DateOfBirth="1990-03-04" />
  <Student Name="Chad" Gender="M"  DateOfBirth="1991-05-06" />
  <Student Name="Dave" Gender="M"  DateOfBirth="1992-07-08">
    <Pet Type="dog" Name="Rover" />
  </Student>
  <Student DateOfBirth="1993-09-10" Gender="F" Name="&#x00C9;mily" />
</Students>
}

; REBOL has a simple built-in XML parser. It's not terribly fancy, but
; it's easy to use. It converts the XML into a nested list of blocks
; which can be accessed using standard REBOL path operators. The only
; annoying part (in this case) is that it does try to preserve
; whitespace, so some of the parsed elements are just things like line
; endings and whatnot, which I need to ignore.

; Once I have drilled down to the individual student records, I can
; just use the standard REBOL 'select' to locate the requested
; property.

data: parse-xml xml
students: data/3/1/3 ; Drill down to student records.
foreach student students [
	if block! = type? student [ ; Ignore whitespace elements.
		print select student/2 "Name"
	]
]
