from __future__ import print_function

def order_disjoint_list_items(data, items):
    #Modifies data list in-place
    itemindices = []
    for item in set(items):
        itemcount = items.count(item)
        #assert data.count(item) >= itemcount, 'More of %r than in data' % item
        lastindex = [-1]
        for i in range(itemcount):
            lastindex.append(data.index(item, lastindex[-1] + 1))
        itemindices += lastindex[1:]
    itemindices.sort()
    for index, item in zip(itemindices, items):
        data[index] = item

if __name__ == '__main__':
    tostring = ' '.join
    for data, items in [ (str.split('the cat sat on the mat'), str.split('mat cat')),
                         (str.split('the cat sat on the mat'), str.split('cat mat')),
                         (list('ABCABCABC'), list('CACA')),
                         (list('ABCABDABE'), list('EADA')),
                         (list('AB'), list('B')),
                         (list('AB'), list('BA')),
                         (list('ABBA'), list('BA')),
                         (list(''), list('')),
                         (list('A'), list('A')),
                         (list('AB'), list('')),
                         (list('ABBA'), list('AB')),
                         (list('ABAB'), list('AB')),
                         (list('ABAB'), list('BABA')),
                         (list('ABCCBA'), list('ACAC')),
                         (list('ABCCBA'), list('CACA')),
                       ]:
        print('Data M: %-24r Order N: %-9r' % (tostring(data), tostring(items)), end=' ')
        order_disjoint_list_items(data, items)
        print("-> M' %r" % tostring(data))
