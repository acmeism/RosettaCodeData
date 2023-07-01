(print o concat o map (fn s => s ^ "\n") o List.filter (String.isPrefix ".") o dirEntries) "."
