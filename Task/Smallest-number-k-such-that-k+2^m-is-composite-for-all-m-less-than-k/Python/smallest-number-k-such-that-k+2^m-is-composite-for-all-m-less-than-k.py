""" wiki/Smallest_number_k_such_that_k%2B2%5Em_is_composite_for_all_m_less_than_k """

from sympy import isprime


def a(k):
    """ returns true if k is a sequence member, false otherwise """
    if k == 1:
        return False

    for m in range(1, k):
        n = 2**m + k
        if isprime(n):
            return False

    return True


if __name__ == '__main__':

    print([i for i in range(1, 5500, 2) if a(i)]) # [773, 2131, 2491, 4471, 5101]
