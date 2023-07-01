import "./trait" for Const

Const["six"] = 6
Const["eight"] = 8
Const["six"] = 7  // ignored, still 6
System.print(Const.entries)
