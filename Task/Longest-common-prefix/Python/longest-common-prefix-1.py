import os.path

def lcp(*s):
    return os.path.commonprefix(s)

assert lcp("interspecies","interstellar","interstate") == "inters"
assert lcp("throne","throne") == "throne"
assert lcp("throne","dungeon") == ""
assert lcp("cheese") == "cheese"
assert lcp("") == ""
assert lcp("prefix","suffix") == ""
assert lcp("foo","foobar") == "foo"
