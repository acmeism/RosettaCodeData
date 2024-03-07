from collections import defaultdict
from itertools import product

class JordanPolyaNumbers:
    def __init__(self):
        self.jordan_polya_set = set()
        self.decompositions = defaultdict(dict)

    def create_jordan_polya(self):
        self.jordan_polya_set.add(1)
        next_set = set()
        self.decompositions[1] = {}
        factorial = 1

        for multiplier in range(2, 21):
            factorial *= multiplier
            for number in list(self.jordan_polya_set):
                while number <= 2**63 - 1 // factorial:
                    original = number
                    number *= factorial
                    next_set.add(number)
                    self.decompositions[number] = self.decompositions[original].copy()
                    self.decompositions[number][multiplier] = self.decompositions[number].get(multiplier, 0) + 1

            self.jordan_polya_set.update(next_set)
            next_set.clear()

    def to_string(self, a_map):
        result = ""
        for key in sorted(a_map.keys(), reverse=True):
            exponent = a_map[key]
            result += f"{key}!" + ("" if exponent == 1 else f"^{exponent}") + " * "
        return result[:-3]

    def display_results(self):
        below_hundred_million = max(n for n in self.jordan_polya_set if n < 100_000_000)
        jordan_polya = sorted(list(self.jordan_polya_set))

        print("The first 50 Jordan-Polya numbers:")
        for i in range(50):
            end = "\n" if (i % 10 == 9) else ""
            print(f"{jordan_polya[i]:5}", end=end)
        print()

        print(f"The largest Jordan-Polya number less than 100 million: {below_hundred_million}")
        print()

        for i in [800, 1050, 1800, 2800, 3800]:
            print(f"The {i}th Jordan-Polya number is: {jordan_polya[i-1]}"
                  f" = {self.to_string(self.decompositions[jordan_polya[i-1]])}")


if __name__ == "__main__":
    jpn = JordanPolyaNumbers()
    jpn.create_jordan_polya()
    jpn.display_results()
