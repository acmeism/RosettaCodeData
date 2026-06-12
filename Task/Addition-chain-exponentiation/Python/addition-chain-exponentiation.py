'''  Rosetta Code task Addition-chain_exponentiation  '''

from math import sqrt
from numpy import array
from mpmath import mpf


class AdditionChains:
    ''' two methods of calculating addition chains '''

    def __init__(self):
        ''' memoization for knuth_path '''
        self.chains, self.idx, self.pos = [[1]], 0, 0
        self.pat, self.lvl = {1: 0}, [[1]]

    def add_chain(self):
        ''' method 1: add chains depth then breadth first until done '''
        newchain = self.chains[self.idx].copy()
        newchain.append(self.chains[self.idx][-1] +
                        self.chains[self.idx][self.pos])
        self.chains.append(newchain)
        if self.pos == len(self.chains[self.idx])-1:
            self.idx += 1
            self.pos = 0
        else:
            self.pos += 1
        return newchain

    def find_chain(self, nexp):
        ''' method 1 interface: search for chain ending with n, adding more as needed '''
        assert nexp > 0
        if nexp == 1:
            return [1]
        chn = next((a for a in self.chains if a[-1] == nexp), None)
        if chn is None:
            while True:
                chn = self.add_chain()
                if chn[-1] == nexp:
                    break

        return chn

    def knuth_path(self, ngoal):
        ''' method 2: knuth method, uses memoization to search for a shorter chain '''
        if ngoal < 1:
            return []
        while not ngoal in self.pat:
            new_lvl = []
            for i in self.lvl[0]:
                for j in self.knuth_path(i):
                    if not i + j in self.pat:
                        self.pat[i + j] = i
                        new_lvl.append(i + j)

            self.lvl[0] = new_lvl

        returnpath = self.knuth_path(self.pat[ngoal])
        returnpath.append(ngoal)
        return returnpath


def cpow(xbase, chain):
    ''' raise xbase by an addition exponentiation chain for what becomes x**chain[-1] '''
    pows, products = 0, {0: 1, 1: xbase}
    for i in chain:
        products[i] = products[pows] * products[i - pows]
        pows = i
    return products[chain[-1]]


if __name__ == '__main__':
    # test both addition chain methods
    acs = AdditionChains()
    print('First one hundred addition chain lengths:')
    for k in range(1, 101):
        print(f'{len(acs.find_chain(k))-1:3}', end='\n'if k % 10 == 0 else '')

    print('\nKnuth chains for addition chains of 31415 and 27182:')
    chns = {m: acs.knuth_path(m) for m in [31415, 27182]}
    for (num, cha) in chns.items():
        print(f'Exponent: {num:10}\n  Addition Chain: {cha[:-1]}')
    print('\n1.00002206445416^31415 =', cpow(1.00002206445416, chns[31415]))
    print('1.00002550055251^27182 =', cpow(1.00002550055251, chns[27182]))
    print('1.000025 + 0.000058i)^27182 =',
          cpow(complex(1.000025, 0.000058), chns[27182]))
    print('1.000022 + 0.000050i)^31415 =',
          cpow(complex(1.000022, 0.000050), chns[31415]))
    sq05 = mpf(sqrt(0.5))
    mat = array([[sq05, 0, sq05, 0, 0, 0], [0, sq05, 0, sq05, 0, 0], [0, sq05, 0, -sq05, 0, 0],
                 [-sq05, 0, sq05, 0, 0, 0], [0, 0, 0, 0, 0, 1], [0, 0, 0, 0, 1, 0]])
    print('matrix A ^ 27182 =')
    print(cpow(mat, chns[27182]))
    print('matrix A ^ 31415 =')
    print(cpow(mat, chns[31415]))
    print('(matrix A ** 27182) ** 31415 =')
    print(cpow(cpow(mat, chns[27182]), chns[31415]))
