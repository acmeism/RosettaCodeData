mut n := [
  "---------- Ice and Fire ------------",
  "                                    ",
  "fire, in end will world the say Some",
  "ice. in say Some                    ",
  "desire of tasted I've what From     ",
  "fire. favor who those with hold I   ",
  "                                    ",
  "... elided paragraph last ...       ",
  "                                    ",
  "Frost Robert -----------------------",
]

println(
  n.map(
    it.fields().reverse().join(' ').trim_space()
  ).join('\n')
)
