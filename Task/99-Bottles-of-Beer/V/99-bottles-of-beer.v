[bottles
  [newline <nowiki>''</nowiki> puts].
  [beer
    [0 =] ['No more bottles of beer' put] if
    [1 =] ['One bottle of beer' put] if
    [1 >] [dup put ' bottles of beer' put] if].
  [0 =] [newline]
    [beer ' on the wall, ' put beer newline
    'Take one down and pass it around, ' put pred beer ' on the wall' puts newline]
  tailrec].

99 bottles
