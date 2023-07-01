def get_next_character(f):
  # note: assumes valid utf-8
  c = f.read(1)
  while c:
    while True:
      try:
        yield c.decode('utf-8')
      except UnicodeDecodeError:
        # we've encountered a multibyte character
        # read another byte and try again
        c += f.read(1)
      else:
        # c was a valid char, and was yielded, continue
        c = f.read(1)
        break

# Usage:
with open("input.txt","rb") as f:
    for c in get_next_character(f):
        print(c)
