from collections import defaultdict

def order_words(words):
    byfirst = defaultdict(set)
    for word in words:
        byfirst[word[0]].add( word )
    #byfirst = dict(byfirst)
    return byfirst

def linkfirst(byfirst, sofar):
    '''\
    For all words matching last char of last word in sofar as FIRST char and not in sofar,
    return longest chain as sofar + chain
    '''

    assert sofar
    chmatch = sofar[-1][-1]
    options = byfirst[chmatch] - set(sofar)
    #print('  linkfirst options: %r %r' % (chmatch, options))
    if not options:
        return sofar
    else:
        alternatives = ( linkfirst(byfirst, list(sofar) + [word])
                         for word in options )
        mx = max( alternatives, key=len )
        #input('linkfirst: %r' % mx)
        return mx

def llfl(words):

    byfirst = order_words(words)
    return max( (linkfirst(byfirst, [word]) for word in words), key=len )

if __name__ == '__main__':
    pokemon = '''audino bagon baltoy banette bidoof braviary bronzor carracosta charmeleon
cresselia croagunk darmanitan deino emboar emolga exeggcute gabite
girafarig gulpin haxorus heatmor heatran ivysaur jellicent jumpluff kangaskhan
kricketune landorus ledyba loudred lumineon lunatone machamp magnezone mamoswine
nosepass petilil pidgeotto pikachu pinsir poliwrath poochyena porygon2
porygonz registeel relicanth remoraid rufflet sableye scolipede scrafty seaking
sealeo silcoon simisear snivy snorlax spoink starly tirtouga trapinch treecko
tyrogue vigoroth vulpix wailord wartortle whismur wingull yamask'''
    pokemon = pokemon.strip().lower().split()
    pokemon = sorted(set(pokemon))
    l = llfl(pokemon)
    for i in range(0, len(l), 8): print(' '.join(l[i:i+8]))
    print(len(l))
