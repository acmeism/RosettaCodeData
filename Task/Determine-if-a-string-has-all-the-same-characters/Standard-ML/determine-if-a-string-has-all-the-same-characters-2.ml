- map chkstring [ "","   ","1","333",".55","tttTTT","4444 444k" ];
val it =
   [("", 0, allSame), ("   ", 3, allSame), ("1", 1, allSame),
    ("333", 3, allSame), (".55", 3, difference ("35", #"5", 2)),
    ("tttTTT", 6, difference ("54", #"T", 4)),
    ("4444 444k", 9, difference ("20", #" ", 5))]:
