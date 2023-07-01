MULTIPLICATION_TABLE = [
    (0, 1, 2, 3, 4, 5, 6, 7, 8, 9),
    (1, 2, 3, 4, 0, 6, 7, 8, 9, 5),
    (2, 3, 4, 0, 1, 7, 8, 9, 5, 6),
    (3, 4, 0, 1, 2, 8, 9, 5, 6, 7),
    (4, 0, 1, 2, 3, 9, 5, 6, 7, 8),
    (5, 9, 8, 7, 6, 0, 4, 3, 2, 1),
    (6, 5, 9, 8, 7, 1, 0, 4, 3, 2),
    (7, 6, 5, 9, 8, 2, 1, 0, 4, 3),
    (8, 7, 6, 5, 9, 3, 2, 1, 0, 4),
    (9, 8, 7, 6, 5, 4, 3, 2, 1, 0),
]

INV = (0, 4, 3, 2, 1, 5, 6, 7, 8, 9)

PERMUTATION_TABLE = [
    (0, 1, 2, 3, 4, 5, 6, 7, 8, 9),
    (1, 5, 7, 6, 2, 8, 3, 0, 9, 4),
    (5, 8, 0, 3, 7, 9, 6, 1, 4, 2),
    (8, 9, 1, 6, 0, 4, 3, 5, 2, 7),
    (9, 4, 5, 3, 1, 2, 6, 8, 7, 0),
    (4, 2, 8, 6, 5, 7, 3, 9, 0, 1),
    (2, 7, 9, 3, 8, 0, 6, 4, 1, 5),
    (7, 0, 4, 6, 9, 1, 3, 2, 5, 8),
]

def verhoeffchecksum(n, validate=True, terse=True, verbose=False):
    """
    Calculate the Verhoeff checksum over `n`.
    Terse mode or with single argument: return True if valid (last digit is a correct check digit).
    If checksum mode, return the expected correct checksum digit.
    If validation mode, return True if last digit checks correctly.
    """
    if verbose:
        print(f"\n{'Validation' if validate else 'Check digit'}",\
            f"calculations for {n}:\n\n i  nᵢ  p[i,nᵢ]   c\n------------------")
    # transform number list
    c, dig = 0, list(str(n if validate else 10 * n))
    for i, ni in enumerate(dig[::-1]):
        p = PERMUTATION_TABLE[i % 8][int(ni)]
        c = MULTIPLICATION_TABLE[c][p]
        if verbose:
            print(f"{i:2}  {ni}      {p}    {c}")

    if verbose and not validate:
        print(f"\ninv({c}) = {INV[c]}")
    if not terse:
        print(f"\nThe validation for '{n}' is {'correct' if c == 0 else 'incorrect'}."\
              if validate else f"\nThe check digit for '{n}' is {INV[c]}.")
    return c == 0 if validate else INV[c]

if __name__ == '__main__':

    for n, va, t, ve in [
        (236, False, False, True), (2363, True, False, True), (2369, True, False, True),
        (12345, False, False, True), (123451, True, False, True), (123459, True, False, True),
        (123456789012, False, False, False), (1234567890120, True, False, False),
        (1234567890129, True, False, False)]:
        verhoeffchecksum(n, va, t, ve)
