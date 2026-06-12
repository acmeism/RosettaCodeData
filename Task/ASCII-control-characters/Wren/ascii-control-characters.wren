import "./dynamic" for Group

var names = [
    "nul", "soh", "stx", "etx", "eot", "enq", "ack", "bel",
    "bs",  "ht",  "lf",  "vt",  "ff",  "cr",  "so",  "si",
    "dle", "dc1", "dc2", "dc3", "dc4", "nak", "syn", "etb",
    "can", "em",  "sub", "esc", "fs",  "gs",  "rs",  "us",
    "space", "del"
]

var values = (0..32).toList + [127]

var Ctrl = Group.create("Ctrl", names, values)

// print some specimen values
System.print(Ctrl.cr)
System.print(Ctrl.del)
