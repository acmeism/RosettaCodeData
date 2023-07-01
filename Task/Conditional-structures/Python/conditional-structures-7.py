# Or without the temp variable
# (it's up to the reader to decide how "pythonic" this is or isn't)
results = {
    0: foo,
    1: bar,
    2: baz,
}.get(x, boz)()
