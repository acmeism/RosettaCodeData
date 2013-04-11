strings = "here are Some sample strings to be sorted".split()

def mykey(x):
    return -len(x), x.upper()

print sorted(strings, key=mykey)
