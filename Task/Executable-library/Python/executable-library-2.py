from collections import Counter

def function_length_frequency(func, hrange):
    return Counter(len(func(n)) for n in hrange).most_common()

if __name__ == '__main__':
    from executable_hailstone_library import hailstone

    upto = 100000
    hlen, freq = function_length_frequency(hailstone, range(1, upto))[0]
    print("The length of hailstone sequence that is most common for\n"
          "hailstone(n) where 1<=n<%i, is %i. It occurs %i times."
          % (upto, hlen, freq))
