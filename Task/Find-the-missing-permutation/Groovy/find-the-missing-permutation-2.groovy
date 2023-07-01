def e = 'ABCD' as List
def p = ['ABCD', 'CABD', 'ACDB', 'DACB', 'BCDA', 'ACBD', 'ADCB', 'CDAB', 'DABC', 'BCAD', 'CADB', 'CDBA',
        'CBAD', 'ABDC', 'ADBC', 'BDCA', 'DCBA', 'BACD', 'BADC', 'BDAC', 'CBDA', 'DBCA', 'DCAB'].collect { it as List }

def mp = missingPerms(e, p)
mp.each { println it }
