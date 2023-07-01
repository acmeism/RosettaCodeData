"""UPC-A barcode reader. Requires Python =>3.6"""
import itertools
import re

RE_BARCODE = re.compile(
    r"^(?P<s_quiet> +)"  # quiet zone
    r"(?P<s_guard># #)"  # start guard
    r"(?P<left>[ #]{42})"  # left digits
    r"(?P<m_guard> # # )"  # middle guard
    r"(?P<right>[ #]{42})"  # right digits
    r"(?P<e_guard># #)"  # end guard
    r"(?P<e_quiet> +)$"  # quiet zone
)

LEFT_DIGITS = {
    (0, 0, 0, 1, 1, 0, 1): 0,
    (0, 0, 1, 1, 0, 0, 1): 1,
    (0, 0, 1, 0, 0, 1, 1): 2,
    (0, 1, 1, 1, 1, 0, 1): 3,
    (0, 1, 0, 0, 0, 1, 1): 4,
    (0, 1, 1, 0, 0, 0, 1): 5,
    (0, 1, 0, 1, 1, 1, 1): 6,
    (0, 1, 1, 1, 0, 1, 1): 7,
    (0, 1, 1, 0, 1, 1, 1): 8,
    (0, 0, 0, 1, 0, 1, 1): 9,
}

RIGHT_DIGITS = {
    (1, 1, 1, 0, 0, 1, 0): 0,
    (1, 1, 0, 0, 1, 1, 0): 1,
    (1, 1, 0, 1, 1, 0, 0): 2,
    (1, 0, 0, 0, 0, 1, 0): 3,
    (1, 0, 1, 1, 1, 0, 0): 4,
    (1, 0, 0, 1, 1, 1, 0): 5,
    (1, 0, 1, 0, 0, 0, 0): 6,
    (1, 0, 0, 0, 1, 0, 0): 7,
    (1, 0, 0, 1, 0, 0, 0): 8,
    (1, 1, 1, 0, 1, 0, 0): 9,
}


MODULES = {
    " ": 0,
    "#": 1,
}

DIGITS_PER_SIDE = 6
MODULES_PER_DIGIT = 7


class ParityError(Exception):
    """Exception raised when a parity error is found."""


class ChecksumError(Exception):
    """Exception raised when check digit does not match."""


def group(iterable, n):
    """Chunk the iterable into groups of size ``n``."""
    args = [iter(iterable)] * n
    return tuple(itertools.zip_longest(*args))


def parse(barcode):
    """Return the 12 digits represented by the given barcode. Raises a
    ParityError if any digit fails the parity check."""
    match = RE_BARCODE.match(barcode)

    # Translate bars and spaces to 1s and 0s so we can do arithmetic
    # with them. Group "modules" into chunks of 7 as we go.
    left = group((MODULES[c] for c in match.group("left")), MODULES_PER_DIGIT)
    right = group((MODULES[c] for c in match.group("right")), MODULES_PER_DIGIT)

    # Parity check
    left, right = check_parity(left, right)

    # Lookup digits
    return tuple(
        itertools.chain(
            (LEFT_DIGITS[d] for d in left),
            (RIGHT_DIGITS[d] for d in right),
        )
    )


def check_parity(left, right):
    """Check left and right parity. Flip left and right if the barcode
    was scanned upside down."""
    # When reading from left to right, each digit on the left should
    # have odd parity, and each digit on the right should have even
    # parity.
    left_parity = sum(sum(d) % 2 for d in left)
    right_parity = sum(sum(d) % 2 for d in right)

    # Use left and right parity to check if the barcode was scanned
    # upside down. Flip it if it was.
    if left_parity == 0 and right_parity == DIGITS_PER_SIDE:
        _left = tuple(tuple(reversed(d)) for d in reversed(right))
        right = tuple(tuple(reversed(d)) for d in reversed(left))
        left = _left
    elif left_parity != DIGITS_PER_SIDE or right_parity != 0:
        # Error condition. Mixed parity.
        error = tuple(
            itertools.chain(
                (LEFT_DIGITS.get(d, "_") for d in left),
                (RIGHT_DIGITS.get(d, "_") for d in right),
            )
        )
        raise ParityError(" ".join(str(d) for d in error))

    return left, right


def checksum(digits):
    """Return the check digit for the given digits. Raises a
    ChecksumError if the check digit does not match."""
    odds = (digits[i] for i in range(0, 11, 2))
    evens = (digits[i] for i in range(1, 10, 2))

    check_digit = (sum(odds) * 3 + sum(evens)) % 10

    if check_digit != 0:
        check_digit = 10 - check_digit

    if digits[-1] != check_digit:
        raise ChecksumError(str(check_digit))

    return check_digit


def main():
    barcodes = [
        "         # #   # ##  #  ## #   ## ### ## ### ## #### # # # ## ##  #   #  ##  ## ###  # ##  ## ### #  # #       ",
        "        # # #   ##   ## # #### #   # ## #   ## #   ## # # # ###  # ###  ##  ## ###  # #  ### ###  # # #         ",
        "         # #    # # #  ###  #   #    # #  #   #    # # # # ## #   ## #   ## #   ##   # # #### ### ## # #         ",
        "       # # ##  ## ##  ##   #  #   #  # ###  # ##  ## # # #   ## ##  #  ### ## ## #   # #### ## #   # #        ",
        "         # # ### ## #   ## ## ###  ##  # ##   #   # ## # # ### #  ## ##  #    # ### #  ## ##  #      # #          ",
        "          # #  #   # ##  ##  #   #   #  # ##  ##  #   # # # # #### #  ##  # #### #### # #  ##  # #### # #         ",
        "         # #  #  ##  ##  # #   ## ##   # ### ## ##   # # # #  #   #   #  #  ### # #    ###  # #  #   # #        ",
        "        # # #    # ##  ##   #  # ##  ##  ### #   #  # # # ### ## ## ### ## ### ### ## #  ##  ### ## # #         ",
        "         # # ### ##   ## # # #### #   ## # #### # #### # # #   #  # ###  #    # ###  # #    # ###  # # #       ",
        "        # # # #### ##   # #### # #   ## ## ### #### # # # #  ### # ###  ###  # # ###  #    # #  ### # #         ",
        "        # # # #### ##   # #### # #   ## ## ### #### # # # #  ### # ###  ###  # # ###  ## ##  #  ### # #         ",
    ]

    for barcode in barcodes:
        try:
            digits = parse(barcode)
        except ParityError as err:
            print(f"{err} parity error!")
            continue

        try:
            check_digit = checksum(digits)
        except ChecksumError as err:
            print(f"{' '.join(str(d) for d in digits)} checksum error! ({err})")
            continue

        print(f"{' '.join(str(d) for d in digits)}")


if __name__ == "__main__":
    main()
