# Use the Longest Common Subsequence algorithm

def shortest_common_supersequence(a, b):
    lcs = longest_common_subsequence(a, b)
    scs = ""
    # Consume lcs
    while len(lcs) > 0:
        if a[0]==lcs[0] and b[0]==lcs[0]:
        # Part of the LCS, so consume from all strings
            scs += lcs[0]
            lcs = lcs[1:]
            a = a[1:]
            b = b[1:]
        elif a[0]==lcs[0]:
            scs += b[0]
            b = b[1:]
        else:
            scs += a[0]
            a = a[1:]
    # append remaining characters
    return scs + a + b
