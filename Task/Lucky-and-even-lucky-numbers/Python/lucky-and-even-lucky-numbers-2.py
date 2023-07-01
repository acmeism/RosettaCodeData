from itertools import islice
import sys, re

class ArgumentError(Exception):
    pass
def arghandler(argstring):
    match_obj = re.match( r"""(?mx)
    (?:
      (?P<SINGLE>
         (?: ^ (?P<SINGLEL> \d+ ) (?:  | \s , \s lucky ) \s* $ )
        |(?: ^ (?P<SINGLEE> \d+ ) (?:  | \s , \s evenLucky ) \s* $ )
      )
     |(?P<KTH>
         (?: ^ (?P<KTHL> \d+ \s \d+ ) (?:  | \s lucky ) \s* $ )
        |(?: ^ (?P<KTHE> \d+ \s \d+ ) (?:  | \s evenLucky ) \s* $ )
      )
     |(?P<RANGE>
         (?: ^ (?P<RANGEL> \d+ \s -\d+ ) (?:  | \s lucky ) \s* $ )
        |(?: ^ (?P<RANGEE> \d+ \s -\d+ ) (?:  | \s evenLucky ) \s* $ )
      )
    )""", argstring)

    if match_obj:
        # Retrieve group(s) by name
        SINGLEL = match_obj.group('SINGLEL')
        SINGLEE = match_obj.group('SINGLEE')
        KTHL = match_obj.group('KTHL')
        KTHE = match_obj.group('KTHE')
        RANGEL = match_obj.group('RANGEL')
        RANGEE = match_obj.group('RANGEE')
        if SINGLEL:
            j = int(SINGLEL)
            assert 0 < j < 10001, "Argument out of range"
            print("Single %i'th lucky number:" % j, end=' ')
            print( list(islice(lgen(), j-1, j))[0] )
        elif SINGLEE:
            j = int(SINGLEE)
            assert 0 < j < 10001, "Argument out of range"
            print("Single %i'th even lucky number:" % j, end=' ')
            print( list(islice(lgen(even=True), j-1, j))[0] )
        elif KTHL:
            j, k = [int(num) for num in KTHL.split()]
            assert 0 < j < 10001, "first argument out of range"
            assert 0 < k < 10001 and k > j, "second argument out of range"
            print("List of %i ... %i lucky numbers:" % (j, k), end=' ')
            for n, luck in enumerate(lgen(), 1):
                if n > k: break
                if n >=j: print(luck, end = ', ')
            print('')
        elif KTHE:
            j, k = [int(num) for num in KTHE.split()]
            assert 0 < j < 10001, "first argument out of range"
            assert 0 < k < 10001 and k > j, "second argument out of range"
            print("List of %i ... %i even lucky numbers:" % (j, k), end=' ')
            for n, luck in enumerate(lgen(even=True), 1):
                if n > k: break
                if n >=j: print(luck, end = ', ')
            print('')
        elif RANGEL:
            j, k = [int(num) for num in RANGEL.split()]
            assert 0 < j < 10001, "first argument out of range"
            assert 0 < -k < 10001 and -k > j, "second argument out of range"
            k = -k
            print("List of lucky numbers in the range %i ... %i :" % (j, k), end=' ')
            for n in lgen():
                if n > k: break
                if n >=j: print(n, end = ', ')
            print('')
        elif RANGEE:
            j, k = [int(num) for num in RANGEE.split()]
            assert 0 < j < 10001, "first argument out of range"
            assert 0 < -k < 10001 and -k > j, "second argument out of range"
            k = -k
            print("List of even lucky numbers in the range %i ... %i :" % (j, k), end=' ')
            for n in lgen(even=True):
                if n > k: break
                if n >=j: print(n, end = ', ')
            print('')
    else:
        raise ArgumentError('''

  Error Parsing Arguments!

  Expected Arguments of the form (where j and k are integers):

      j                #  Jth       lucky number
      j  ,      lucky  #  Jth       lucky number
      j  ,  evenLucky  #  Jth  even lucky number
                       #
      j  k             #  Jth  through  Kth (inclusive)       lucky numbers
      j  k      lucky  #  Jth  through  Kth (inclusive)       lucky numbers
      j  k  evenLucky  #  Jth  through  Kth (inclusive)  even lucky numbers
                       #
      j -k             #  all       lucky numbers in the range  j --? |k|
      j -k      lucky  #  all       lucky numbers in the range  j --? |k|
      j -k  evenLucky  #  all  even lucky numbers in the range  j --? |k|
        ''')

if __name__ == '__main__':
    arghandler(' '.join(sys.argv[1:]))
