def int_to_english(n):
    if n < 0: return "minus " + int_to_english(-n)
    if n < 10:
        return ["zero", "one", "two", "three", "four", "five",
                "six", "seven", "eight", "nine"][n]
    if n < 20:
        return ["ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen",
                "sixteen", "seventeen", "eighteen", "nineteen"][n-10]
    if n < 100:
        tens = ["twenty", "thirty", "forty", "fifty", "sixty",
                "seventy", "eighty", "ninety"][(n // 10 - 2)%10]
        if n % 10 != 0:
            return tens + "-" + int_to_english(n % 10)
        else:
            return tens
    if n < 1000:
        if n % 100 == 0:
            return int_to_english(n // 100) + " hundred"
        else:
            return int_to_english(n // 100) + " hundred and " +\
               int_to_english(n % 100)
    # http://www.isthe.com/chongo/tech/math/number/tenpower.html
    powers = [("thousand", 3), ("million", 6),
              ("billion", 9), ("trillion", 12), ("quadrillion", 15),
              ("quintillion", 18), ("sextillion", 21), ("septillion", 24),
              ("octillion", 27), ("nonillion", 30), ("decillion", 33),
              ("undecillion", 36), ("duodecillion", 39), ("tredecillion", 42),
              ("quattuordecillion", 45), ("quindecillion", 48),
              ("sexdecillion", 51), ("eptendecillion", 54),
              ("octadecillion", 57), ("novemdecillion", 61),
              ("vigintillion", 64)]
    ns = str(n)
    idx = len(powers) - 1
    while True:
        d = powers[idx][1]
        if len(ns) > d:
            first = int_to_english(int(ns[:-d]))
            second = int_to_english(int(ns[-d:]))
            if second == "zero":
                return first + " " + powers[idx][0]
            else:
                return first + " " + powers[idx][0] + " " + second
        idx = idx - 1

if __name__ == "__main__":
    print(int_to_english(42))
    print(int_to_english(3 ** 7))
    print(int_to_english(2 ** 100))
    print(int_to_english(10 ** (2*64)))
