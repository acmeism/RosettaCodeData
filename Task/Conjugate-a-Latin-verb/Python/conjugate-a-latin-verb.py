#!/usr/bin/python


def conjugate(infinitive):
    if not infinitive[-3:] == "are":
        print("'", infinitive, "' non prima coniugatio verbi.\n", sep='')
        return False

    stem = infinitive[0:-3]
    if len(stem) == 0:
        print("\'", infinitive, "\' non satis diu conjugatus\n", sep='')
        return False

    print("Praesens indicativi temporis of '", infinitive, "':", sep='')
    for ending in ("o", "as", "at", "amus", "atis", "ant"):
        print("     ", stem, ending, sep='')
    print()


if __name__ == '__main__':
    for infinitive in ("amare", "dare", "qwerty", "are"):
        conjugate(infinitive)
