def hashJoin(table1, index1, table2, index2)
  # hash phase
  h = table1.group_by {|s| s[index1]}
  h.default = []
  # join phase
  table2.collect {|r|
    h[r[index2]].collect {|s| [s, r]}
  }.flatten(1)
end

table1 = [[27, "Jonah"],
          [18, "Alan"],
          [28, "Glory"],
          [18, "Popeye"],
          [28, "Alan"]]
table2 = [["Jonah", "Whales"],
          ["Jonah", "Spiders"],
          ["Alan", "Ghosts"],
          ["Alan", "Zombies"],
          ["Glory", "Buffy"]]

hashJoin(table1, 1, table2, 0).each { |row| p row }
