import bisect
try: input = raw_input
except: pass

class GuessNumberFakeList(object):
    def __getitem__(self, i):
        s = input("Is your number less than or equal to %d?" % i)
        return 0 if s.lower().startswith('y') else -1

LOWER, UPPER = 0, 100

if __name__ == "__main__":
    print("""Instructions:
Think of integer number from %d (inclusive) to %d (exclusive) and
I will guess it. After each guess, I will ask you if it is less than
or equal to some number, and you will respond with "yes" or "no".
""" % (LOWER, UPPER))
    result = bisect.bisect_left(GuessNumberFakeList(), 0, LOWER, UPPER)
    print("Your number is %d." % result)
