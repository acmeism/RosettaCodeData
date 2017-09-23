def table1:
  [ {"age": 27, "name": "Jonah"},
    {"age": 18, "name": "Alan"},
    {"age": 28, "name": "Glory"},
    {"age": 18, "name": "Popeye"},
    {"age": 28, "name": "Alan"} ]
;

def table2:
  [ {"name": "Jonah", "nemesis": "Whales"},
    {"name": "Jonah", "nemesis": "Spiders"},
    {"name": "Alan", "nemesis": "Ghosts"},
    {"name": "Alan", "nemesis": "Zombies"},
    {"name": "Glory", "nemesis": "Buffy"} ]
;

def table1a:
  [[27, "Jonah"],
   [18, "Alan"],
   [28, "Glory"],
   [18, "Popeye"],
   [28, "Alan"] ]
;

def table2a:
  [["Jonah", "Whales"],
   ["Jonah", "Spiders"],
   ["Alan", "Ghosts"],
   ["Alan", "Zombies"],
   ["Glory", "Buffy"],
   ["Holmes", "Moriarty"] ]
;

def pp:
  reduce .[] as $row (""; . + "\n" + ($row|tostring));

( hashJoin(table1; "name"; table2; "name"),
  hashJoin(table1a; 1; table2a; 0)
) | pp
