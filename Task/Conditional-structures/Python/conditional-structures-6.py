# The above, but with a dict literal
dispatcher = {
    0: foo,
    1: bar,
    2: baz,
}
# ...
results = dispatcher.get(x, boz)()
