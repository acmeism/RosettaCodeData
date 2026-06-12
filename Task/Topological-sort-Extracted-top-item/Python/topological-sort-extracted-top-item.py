try:
    from functools import reduce
except: pass

# Python 3.x: def topx(data:'dict', tops:'set'=None) -> 'list':
def topx(data, tops=None):
    'Extract the set of top-level(s) in topological order'
    for k, v in data.items():
        v.discard(k) # Ignore self dependencies
    if tops is None:
        tops = toplevels(data)
    return _topx(data, tops, [], set())

def _topx(data, tops, _sofar, _sofar_set):
    'Recursive topological extractor'
    _sofar += [tops] # Accumulates order in reverse
    _sofar_set.union(tops)
    depends = reduce(set.union, (data.get(top, set()) for top in tops))
    if depends:
        _topx(data, depends, _sofar, _sofar_set)
    ordered, accum = [], set()
    for s in _sofar[::-1]:
        ordered += [sorted(s - accum)]
        accum |= s
    return ordered

def printorder(order):
    'Prettyprint topological ordering'
    if order:
        print("First: " + ', '.join(str(s) for s in order[0]))
    for o in order[1:]:
        print(" Then: " + ', '.join(str(s) for s in o))

def toplevels(data):
    '''\
    Extract all top levels from dependency data
    Top levels are never dependents
    '''
    for k, v in data.items():
        v.discard(k) # Ignore self dependencies
    dependents = reduce(set.union, data.values())
    return  set(data.keys()) - dependents

if __name__ == '__main__':
    data = dict(
        top1  = set('ip1 des1 ip2'.split()),
        top2  = set('ip2 des1 ip3'.split()),
        des1  = set('des1a des1b des1c'.split()),
        des1a = set('des1a1 des1a2'.split()),
        des1c = set('des1c1 extra1'.split()),
        ip2   = set('ip2a ip2b ip2c ipcommon'.split()),
        ip1   = set('ip1a ipcommon extra1'.split()),
        )

    tops = toplevels(data)
    print("The top levels of the dependency graph are: " + ' '.join(tops))

    for t in sorted(tops):
        print("\nThe compile order for top level: %s is..." % t)
        printorder(topx(data, set([t])))
    if len(tops) > 1:
        print("\nThe compile order for top levels: %s is..."
              % ' and '.join(str(s) for s in sorted(tops)) )
        printorder(topx(data, tops))
