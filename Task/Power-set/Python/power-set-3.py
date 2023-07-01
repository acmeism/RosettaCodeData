def powersequence(val):
    ''' Generate a 'powerset' for sequence types that are indexable by integers.
        Uses a binary count to enumerate the members and returns a list

        Examples:
            >>> powersequence('STR')   # String
            ['', 'S', 'T', 'ST', 'R', 'SR', 'TR', 'STR']
            >>> powersequence([0,1,2]) # List
            [[], [0], [1], [0, 1], [2], [0, 2], [1, 2], [0, 1, 2]]
            >>> powersequence((3,4,5)) # Tuple
            [(), (3,), (4,), (3, 4), (5,), (3, 5), (4, 5), (3, 4, 5)]
            >>>
    '''
    vtype = type(val); vlen = len(val); vrange = range(vlen)
    return [ reduce( lambda x,y: x+y, (val[i:i+1] for i in vrange if 2**i & n), vtype())
             for n in range(2**vlen) ]

def powerset(s):
    ''' Generate the powerset of s

        Example:
            >>> powerset(set([6,7,8]))
            set([frozenset([7]), frozenset([8, 6, 7]), frozenset([6]), frozenset([6, 7]), frozenset([]), frozenset([8]), frozenset([8, 7]), frozenset([8, 6])])
    '''
    return set( frozenset(x) for x in powersequence(list(s)) )
