import gleam/dict

pub fn main() {
  // create empty dictionary
  let _ = dict.new()

  // create dictionary from list of tuples
  let stuff = dict.from_list([#("key1", 1), #("key2", 2)])

  // retrieve value at key
  let _ = dict.get(stuff, "key1")

  // add key-value pair
  let _new_dict = dict.insert(stuff, "key3", 3)

  // test key existence
  let _ = dict.has_key(stuff, "key1")
}
