# keyname should be (or evaluate to) a string
def set(keyname; value):
  if type == "object" and .type and has(keyname) then .[keyname] = value
  else error("set: invalid type: \(.)")
  end;
