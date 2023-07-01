define printArgs(...items) => stdoutnl(#items)
define printEachArg(...) => with i in #rest do stdoutnl(#i)

printArgs('a', 2, (:3))
printEachArg('a', 2, (:3))
