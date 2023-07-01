" Creating a dictionary with some initial values
let dict = {"one": 1, "two": 2}

" Retrieving a value
let two_a = dict["two"]
let two_b = dict.two
let two_c = get(dict, "two", "default value for missing key")

" Modifying a value
let dict["one"] = 1.0
let dict.two = 2.0

" Adding a new value
let dict["three"] = 3
let dict.four = 4

" Removing a value
let one = remove(dict, "one")
unlet dict["two"]
unlet dict.three
