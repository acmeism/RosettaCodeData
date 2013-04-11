$ awk '{if($0~/[A-Z]/)print "uppercase detected"}'
abc
ABC
uppercase detected
