def consolidate(sets):
    '''
    >>> # Define some variables
    >>> A,B,C,D,E,F,G,H,I,J,K = 'A,B,C,D,E,F,G,H,I,J,K'.split(',')
    >>> # Consolidate some lists of sets
    >>> consolidate([{A,B}, {C,D}])
    [{'A', 'B'}, {'C', 'D'}]
    >>> consolidate([{A,B}, {B,D}])
    [{'A', 'B', 'D'}]
    >>> consolidate([{A,B}, {C,D}, {D,B}])
    [{'A', 'C', 'B', 'D'}]
    >>> consolidate([{H,I,K}, {A,B}, {C,D}, {D,B}, {F,G,H}])
    [{'A', 'C', 'B', 'D'}, {'G', 'F', 'I', 'H', 'K'}]
    >>> consolidate([{A,H}, {H,I,K}, {A,B}, {C,D}, {D,B}, {F,G,H}])
    [{'A', 'C', 'B', 'D', 'G', 'F', 'I', 'H', 'K'}]
    >>> consolidate([{H,I,K}, {A,B}, {C,D}, {D,B}, {F,G,H}, {A,H}])
    [{'A', 'C', 'B', 'D', 'G', 'F', 'I', 'H', 'K'}]
    >>> # Confirm order-independence
    >>> from copy import deepcopy
    >>> import itertools
    >>> sets = [{H,I,K}, {A,B}, {C,D}, {D,B}, {F,G,H}, {A,H}]
    >>> answer = consolidate(deepcopy(sets))
    >>> for perm in itertools.permutations(sets):
            assert consolidate(deepcopy(perm)) == answer


    >>> answer
    [{'A', 'C', 'B', 'D', 'G', 'F', 'I', 'H', 'K'}]
    >>> len(list(itertools.permutations(sets)))
    720
    >>>
    '''
    setlist = [s for s in sets if s]
    for i, s1 in enumerate(setlist):
        if s1:
            for s2 in setlist[i+1:]:
                intersection = s1.intersection(s2)
                if intersection:
                    s2.update(s1)
                    s1.clear()
                    s1 = s2
    return [s for s in setlist if s]
