set len [llength "Apples Oranges"]  ;# 2
set len [llength {Apples Oranges}]  ;# 2
set fruit { apples oranges cherries bananas}
set len [llength $fruit]
puts stdout "($len) : $fruit"
