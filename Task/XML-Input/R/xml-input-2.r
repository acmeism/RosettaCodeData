#Convert to an XML tree
xmltree <- xmlTreeParse(str)

#Retrieve the students, and how many there are
students <- xmltree$doc$children$Students
nstudents <- length(students)

#Get each of their names
studentsnames <- character(nstudents)
for(i in 1:nstudents)
{
   this.student <- students$children[i]$Student
   studentsnames[i] <- this.student$attributes["Name"]
}

#Change the encoding so that Emily displays correctly
Encoding(studentsnames) <- "UTF-8"
studentsnames
