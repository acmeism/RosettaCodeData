dispatcher = dict()
dispatcher[0]=foo  # Not foo(): we bind the dictionary entry to the function's object,
                   # NOT to the results returned by an invocation of the function
dispatcher[1]=bar
dispatcher[2]=baz  # foo,bar, baz, and boz are defined functions.
# Then later
results = dispatcher.get(x, boz)()  # binding results to a name is optional
# or with no "default" case:
if x in dispatcher:
    results=dispatcher[x]()
