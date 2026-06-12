def schemaLoc = "http://venus.eas.asu.edu/WSRepository/xml/Courses.xsd"
def docLoc = "http://venus.eas.asu.edu/WSRepository/xml/Courses.xml"
println "Document is ${validate(schemaLoc, docLoc)? 'valid' : 'invalid'}"
