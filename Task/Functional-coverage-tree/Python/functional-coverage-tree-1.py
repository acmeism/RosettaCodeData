from itertools import zip_longest


fc2 = '''\
cleaning,,
    house1,40,
        bedrooms,,.25
        bathrooms,,
            bathroom1,,.5
            bathroom2,,
            outside_lavatory,,1
        attic,,.75
        kitchen,,.1
        living_rooms,,
            lounge,,
            dining_room,,
            conservatory,,
            playroom,,1
        basement,,
        garage,,
        garden,,.8
    house2,60,
        upstairs,,
            bedrooms,,
                suite_1,,
                suite_2,,
                bedroom_3,,
                bedroom_4,,
            bathroom,,
            toilet,,
            attics,,.6
        groundfloor,,
            kitchen,,
            living_rooms,,
                lounge,,
                dining_room,,
                conservatory,,
                playroom,,
            wet_room_&_toilet,,
            garage,,
            garden,,.9
            hot_tub_suite,,1
        basement,,
            cellars,,1
            wine_cellar,,1
            cinema,,.75

'''

NAME, WT, COV = 0, 1, 2

def right_type(txt):
    try:
        return float(txt)
    except ValueError:
        return txt

def commas_to_list(the_list, lines, start_indent=0):
    '''
    Output format is a nest of lists and tuples
    lists are for coverage leaves without children items in the list are name, weight, coverage
    tuples are 2-tuples for nodes with children. The first element is a list representing the
    name, weight, coverage of the node (some to be calculated); the second element is a list of
    child elements which may be 2-tuples or lists as above.

    the_list is modified in-place
    lines must be a generator of successive lines of input like fc2
    '''
    for n, line in lines:
        indent = 0
        while line.startswith(' ' * (4 * indent)):
            indent += 1
        indent -= 1
        fields = [right_type(f) for f in line.strip().split(',')]
        if indent == start_indent:
            the_list.append(fields)
        elif indent > start_indent:
            lst = [fields]
            sub = commas_to_list(lst, lines, indent)
            the_list[-1] = (the_list[-1], lst)
            if sub not in (None, ['']) :
                the_list.append(sub)
        else:
            return fields if fields else None
    return None


def pptreefields(lst, indent=0, widths=['%-32s', '%-8g', '%-10g']):
    '''
    Pretty prints the format described from function commas_to_list as a table with
    names in the first column suitably indented and all columns having a fixed
    minimum column width.
    '''
    lhs = ' ' * (4 * indent)
    for item in lst:
        if type(item) != tuple:
            name, *rest = item
            print(widths[0] % (lhs + name), end='|')
            for width, item in zip_longest(widths[1:len(rest)], rest, fillvalue=widths[-1]):
                if type(item) == str:
                    width = width[:-1] + 's'
                print(width % item, end='|')
            print()
        else:
            item, children = item
            name, *rest = item
            print(widths[0] % (lhs + name), end='|')
            for width, item in zip_longest(widths[1:len(rest)], rest, fillvalue=widths[-1]):
                if type(item) == str:
                    width = width[:-1] + 's'
                print(width % item, end='|')
            print()
            pptreefields(children, indent+1)


def default_field(node_list):
    node_list[WT] = node_list[WT] if node_list[WT] else 1.0
    node_list[COV] = node_list[COV] if node_list[COV] else 0.0

def depth_first(tree, visitor=default_field):
    for item in tree:
        if type(item) == tuple:
            item, children = item
            depth_first(children, visitor)
        visitor(item)


def covercalc(tree):
    '''
    Depth first weighted average of coverage
    '''
    sum_covwt, sum_wt = 0, 0
    for item in tree:
        if type(item) == tuple:
            item, children = item
            item[COV] = covercalc(children)
        sum_wt  += item[WT]
        sum_covwt += item[COV] * item[WT]
    cov = sum_covwt / sum_wt
    return cov

if __name__ == '__main__':
    lstc = []
    commas_to_list(lstc, ((n, ln) for n, ln in enumerate(fc2.split('\n'))))
    #pp(lstc, width=1, indent=4, compact=1)

    #print('\n\nEXPANDED DEFAULTS\n')
    depth_first(lstc)
    #pptreefields(['NAME_HIERARCHY WEIGHT COVERAGE'.split()] + lstc)

    print('\n\nTOP COVERAGE = %f\n' % covercalc(lstc))
    depth_first(lstc)
    pptreefields(['NAME_HIERARCHY WEIGHT COVERAGE'.split()] + lstc)
