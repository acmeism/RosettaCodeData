def _test(consolidate=consolidate):

    def freze(list_of_sets):
        'return a set of frozensets from the list of sets to allow comparison'
        return set(frozenset(s) for s in list_of_sets)

    # Define some variables
    A,B,C,D,E,F,G,H,I,J,K = 'A,B,C,D,E,F,G,H,I,J,K'.split(',')
    # Consolidate some lists of sets
    assert (freze(consolidate([{A,B}, {C,D}])) == freze([{'A', 'B'}, {'C', 'D'}]))
    assert (freze(consolidate([{A,B}, {B,D}])) == freze([{'A', 'B', 'D'}]))
    assert (freze(consolidate([{A,B}, {C,D}, {D,B}])) == freze([{'A', 'C', 'B', 'D'}]))
    assert (freze(consolidate([{H,I,K}, {A,B}, {C,D}, {D,B}, {F,G,H}])) ==
             freze([{'A', 'C', 'B', 'D'}, {'G', 'F', 'I', 'H', 'K'}]))
    assert (freze(consolidate([{A,H}, {H,I,K}, {A,B}, {C,D}, {D,B}, {F,G,H}])) ==
             freze([{'A', 'C', 'B', 'D', 'G', 'F', 'I', 'H', 'K'}]))
    assert (freze(consolidate([{H,I,K}, {A,B}, {C,D}, {D,B}, {F,G,H}, {A,H}])) ==
             freze([{'A', 'C', 'B', 'D', 'G', 'F', 'I', 'H', 'K'}]))
    # Confirm order-independence
    from copy import deepcopy
    import itertools
    sets = [{H,I,K}, {A,B}, {C,D}, {D,B}, {F,G,H}, {A,H}]
    answer = consolidate(deepcopy(sets))
    for perm in itertools.permutations(sets):
            assert consolidate(deepcopy(perm)) == answer

    assert (answer == [{'A', 'C', 'B', 'D', 'G', 'F', 'I', 'H', 'K'}])
    assert (len(list(itertools.permutations(sets))) == 720)

    print('_test(%s) complete' % consolidate.__name__)

if __name__ == '__main__':
    _test(consolidate)
    _test(conso)
