txt = "Some more text"
assert txt[4] == " "
assert txt[0:4] == "Some"
assert txt[:4] == "Some" # you can omit the starting index if 0
assert txt[5:9] == "more"
assert txt[5:] == "more text" # omitting the second index means "to the end"
