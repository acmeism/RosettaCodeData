from itertools import takewhile

def lcp(*s):
    return ''.join(ch[0] for ch in takewhile(lambda x: min(x) == max(x),
					     zip(*s)))

assert lcp("interspecies","interstellar","interstate") == "inters"
assert lcp("throne","throne") == "throne"
assert lcp("throne","dungeon") == ""
assert lcp("cheese") == "cheese"
assert lcp("") == ""
assert lcp("prefix","suffix") == ""
assert lcp("foo","foobar") == "foo"
