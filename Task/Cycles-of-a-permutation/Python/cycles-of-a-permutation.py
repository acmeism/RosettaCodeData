""" For Rosetta Code task Cycles_of_a_permutation """

from math import lcm # in python 3.9+

class Perm:
    """ 1 -based permutations of range of integers """
    def __init__(self, range_or_list):
        """ make a perm from a list or range of integers """
        self.a = list(range_or_list)
        assert sorted(self.a) == list(range(1, len(self.a) + 1)),\
            'Perm should be a shuffled 1-based range'

    def __repr__(self):
        return 'Permutation class Perm'

    def cycleformat(self, AlfBettyForm = False):
        """ stringify the Perm as its cycles, optionally if Rosetta Code task format """
        p = self.inv() if AlfBettyForm else self
        cyclestrings = ["(" + " ".join([str(i) for i in c]) + ")" for c in p.cycles()]
        return '( ' + ' '.join(cyclestrings) + ' )'

    def onelineformat(self):
        """ stringify the Perm in one-line permutation format """
        return '[ ' + ' '.join([str(i) for i in self.a]) + ' ]'

    def len(self):
        """ length """
        return len(self.a)

    def sign(self):
        """ sign """
        return 1 if sum([len(c) % 2 == 0 for c in self.cycles()]) % 2 == 0 else -1

    def order(self):
        """ order of permutation for Perm """
        return lcm(*[len(c) for c in self.cycles()])

    def __mul__(self, p2):
        """ Composition of Perm permutations with the * operator """
        length = len(self.a)
        assert length == len(p2.a), 'Permutations must be of same length'
        return Perm([self.a[p2.a[i] - 1] for i in range(len(self.a))])

    def inv(self):
        """ inverse of a Perm """
        length = len(self.a)
        newa = [0 for _ in range(length)]
        for idx in range(length):
            jidx = self.a[idx]
            newa[jidx - 1] = idx + 1
        return Perm(newa)

    def cycles(self, *, includesingles = False):
        """
        Get cycles of a Perm permutation as a list of integer lists,
        optionally with single cycles included, otherwise omitiing singles
        """
        v = self.a
        length = len(v)
        unchecked = [True] * length
        foundcycles = []
        for idx in range(length):
            if unchecked[idx]:
                c = [idx + 1]
                unchecked[idx] = False
                jidx = idx
                while unchecked[v[jidx] - 1]:
                    jidx = v[jidx]
                    c.append(jidx)
                    jidx -= 1
                    unchecked[jidx] = False
                if len(c) > 1 or includesingles:
                    foundcycles.append(c)

        return sorted(foundcycles)



def cycles_to_Perm(cycles, *, addsingles = True):
    """ Create a Perm from a vector of cycles """
    elements = [e for c in cycles for e in c]
    allpossible = list(range(1, len(elements) + 1))
    if addsingles:
        missings = [x for x in allpossible if not x in elements]
        for elem in missings:
            cycles.append([elem])
            elements.append(elem)

    assert sorted(elements) == allpossible, 'Invalid cycles for creating a Perm'
    a = [0 for _ in range(len(elements))]
    for c in cycles:
        length = len(c)
        for idx in range(length):
            jidx, n = c[idx], c[(idx + 1) % length]
            a[jidx - 1] = n
    return Perm(a)


def string_to_Perm(s):
    """ Create a Perm from a string with only one of each of its letters """
    letters = sorted(list(set(list(s))))
    return Perm([letters.index(c) + 1 for c in s])

def two_string_to_Perm(s1, s2):
    """ Create a Perm from two strings permuting first string to the second one """
    return Perm([s1.index(c) + 1 for c in s2])

def permutestring(s, p):
    """ Create a permuted string from another string using Perm p """
    return ''.join([s[i - 1] for i in p.a])


if __name__ == '__main__':
    # Testing code

    days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
    daystrings = ['HANDYCOILSERUPT', 'SPOILUNDERYACHT', 'DRAINSTYLEPOUCH',
       'DITCHSYRUPALONE', 'SOAPYTHIRDUNCLE', 'SHINEPARTYCLOUD', 'RADIOLUNCHTYPES']
    dayperms = [two_string_to_Perm(daystrings[(i - 1) % 7], daystrings[i]) for i in range(7)]

    print('On Thursdays Alf and Betty should rearrange\ntheir letters using these cycles:',
       '      ', dayperms[3].cycleformat(True), '\n\n\nSo that ', daystrings[2], ' becomes ',
       daystrings[3], '\n\nor they could use the one-line notation:  ',
       dayperms[3].onelineformat(),
       '\n\n\n\nTo revert to the Wednesday arrangement they\nshould use these cycles:      ',
        dayperms[3].inv().cycleformat(True), '\n\n\nor with the one-line notation:  ',
        dayperms[3].inv().onelineformat(), '\n\n\nSo that ', daystrings[3], ' becomes ',
        daystrings[2],
        '\n\n\n\nStarting with the Sunday arrangement and applying each of the daily',
        '\npermutations consecutively, the arrangements will be:\n\n       ',
        daystrings[6], '\n')
    for i in range(7):
        if i == 6:
            print()
        print(days[i], ':  ', permutestring(daystrings[(i - 1) % 7], dayperms[i]))

    print('\n\n\nTo go from Wednesday to Friday in a single step they should use these cycles: ')
    print(two_string_to_Perm(daystrings[2], daystrings[4]).cycleformat(True))
    print('\n\nSo that ', daystrings[2], ' becomes ', daystrings[4])
    print('\n\n\nThese are the signatures of the permutations:\n\n  Mon Tue Wed Thu Fri Sat Sun')
    for i in range(7):
        j = 6 if i == 0 else i - 1
        print(str(two_string_to_Perm(daystrings[(i - 1) % 7],
           daystrings[i]).sign()).rjust(4), end='')

    print('\n\n\nThese are the orders of the permutations:\n\n  Mon Tue Wed Thu Fri Sat Sun')
    for i in range(7):
        print(str(dayperms[i].order()).rjust(4), end='')

    print("\n\nApplying the Friday cycle to a string 10 times:\n")
    PFRI, SPE = dayperms[4], 'STOREDAILYPUNCH'
    print("    ", SPE, '\n')
    for i in range(10):
        SPE = permutestring(SPE, PFRI)
        print(str(i+1).rjust(2), ' ', SPE, '\n' if i == 8 else '')
