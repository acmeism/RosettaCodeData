#!/usr/bin/env python
import string

TRANSLATION_TABLE = str.maketrans(
    string.ascii_uppercase + string.ascii_lowercase,
    string.ascii_uppercase[13:] + string.ascii_uppercase[:13] +
    string.ascii_lowercase[13:] + string.ascii_lowercase[:13]
)


def rot13(s):
    """Return the rot-13 encoding of s."""
    return s.translate(TRANSLATION_TABLE)


if __name__ == "__main__":
    """rot-13 encode the input files, or stdin if no files are provided."""
    import fileinput
    for line in fileinput.input():
        print(rot13(line), end="")
