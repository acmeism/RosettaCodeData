import re

RE_RANGE = re.compile(r"(-?\d+)(?:-(-?\d+))?(?:,|$)")

def expand(expression):
    for start, stop in RE_RANGE.findall(expression):
        yield from range(int(start), int(stop or start) + 1)

print(list(expand("-6,-3--1,3-5,7-11,14,15,17-20")))
