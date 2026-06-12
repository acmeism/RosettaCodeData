def ascii_control_character_names: [
    "nul", "soh", "stx", "etx", "eot", "enq", "ack", "bel",
    "bs",  "ht",  "lf",  "vt",  "ff",  "cr",  "so",  "si",
    "dle", "dc1", "dc2", "dc3", "dc4", "nak", "syn", "etb",
    "can", "em",  "sub", "esc", "fs",  "gs",  "rs",  "us",
    "space", "del"
];

def Ctrl:
  ascii_control_character_names as $a
  | reduce range(0; $a|length) as $i ({}; .[$a[$i]] = $i)
  | .["del"] = 127;

def examples:
  Ctrl as $Ctrl
  | "Ctrl.cr => \($Ctrl.cr)",
    "Ctrl.del => \($Ctrl.del)",
    "Ctrl.space => \($Ctrl.space)";

examples
