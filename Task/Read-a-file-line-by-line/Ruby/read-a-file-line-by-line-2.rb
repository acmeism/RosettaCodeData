# File inherits from IO, so File.foreach also works.
File.foreach("foobar.txt") {|line| puts line}
