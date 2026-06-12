import math
import os


class Shipment:
    def __init__(self, quantity=0.0, cost_per_unit=0.0, r=0, c=0):
        self.quantity = quantity
        self.cost_per_unit = cost_per_unit
        self.r = r
        self.c = c

    def __eq__(self, other):
        if isinstance(self, type(other)):
            return (self.quantity == other.quantity and
                    self.cost_per_unit == other.cost_per_unit and
                    self.r == other.r and
                    self.c == other.c)
        return False

    def __ne__(self, other):
        return not self.__eq__(other)


ship_zero = Shipment()


class Transport:
    def __init__(self, filename):
        self.filename = filename
        self.supply = []
        self.demand = []
        self.costs = []
        self.matrix = []
        self.read_data()

    def read_data(self):
        with open(self.filename, 'r') as f:
            words = f.read().split()
        num_sources = int(words[0])
        num_dests = int(words[1])
        self.supply = [int(words[2 + i]) for i in range(num_sources)]
        self.demand = [int(words[2 + num_sources + i]) for i in range(num_dests)]

        # fix imbalance
        total_src = sum(self.supply)
        total_dst = sum(self.demand)
        diff = total_src - total_dst
        if diff > 0:
            self.demand.append(diff)
        elif diff < 0:
            self.supply.append(-diff)

        self.costs = [[0.0] * len(self.demand) for _ in range(len(self.supply))]
        self.matrix = [[ship_zero] * len(self.demand) for _ in range(len(self.supply))]

        k = 2 + num_sources + num_dests
        for i in range(num_sources):
            for j in range(num_dests):
                self.costs[i][j] = float(words[k])
                k += 1

    def min_of(self, i, j):
        return i if i < j else j

    def north_west_corner_rule(self):
        northwest = 0
        for r in range(len(self.supply)):
            for c in range(northwest, len(self.demand)):
                quantity = self.min_of(self.supply[r], self.demand[c])
                if quantity > 0:
                    self.matrix[r][c] = Shipment(float(quantity), self.costs[r][c], r, c)
                    self.supply[r] -= quantity
                    self.demand[c] -= quantity
                    if self.supply[r] == 0:
                        northwest = c
                        break

    def stepping_stone(self):
        max_reduction = 0.0
        move = None
        leaving = ship_zero
        self.fix_degenerate_case()

        for r in range(len(self.supply)):
            for c in range(len(self.demand)):
                if self.matrix[r][c] != ship_zero:
                    continue

                trial = Shipment(0, self.costs[r][c], r, c)
                path = self.get_closed_path(trial)
                reduction = 0.0
                lowest_quantity = float('inf')
                leaving_candidate = ship_zero
                plus = True

                for s in path:
                    if plus:
                        reduction += s.cost_per_unit
                    else:
                        reduction -= s.cost_per_unit
                        if s.quantity < lowest_quantity:
                            leaving_candidate = s
                            lowest_quantity = s.quantity
                    plus = not plus

                if reduction < max_reduction:
                    move = path
                    leaving = leaving_candidate
                    max_reduction = reduction

        if move:
            q = leaving.quantity
            plus = True
            for s in move:
                if plus:
                    s.quantity += q
                else:
                    s.quantity -= q

                if s.quantity == 0:
                    self.matrix[s.r][s.c] = ship_zero
                else:
                    self.matrix[s.r][s.c] = s
                plus = not plus
            self.stepping_stone()

    def matrix_to_list(self):
        l = []
        for m in self.matrix:
            for s in m:
                if s != ship_zero:
                    l.append(s)
        return l

    def get_closed_path(self, s):
        path = self.matrix_to_list()
        path.insert(0, s)

        # remove (and keep removing) elements that do not have a
        # vertical AND horizontal neighbor
        while True:
            removals = 0
            temp_path = path[:]
            for e in temp_path:
                nbrs = self.get_neighbors(e, path)
                if nbrs[0] == ship_zero or nbrs[1] == ship_zero:
                    path.remove(e)
                    removals += 1
            if removals == 0:
                break

        # place the remaining elements in the correct plus-minus order
        stones = [None] * len(path)
        prev = s
        for i in range(len(stones)):
            stones[i] = prev
            prev = self.get_neighbors(prev, path)[i % 2]
        return stones

    def get_neighbors(self, s, lst):
        nbrs = [ship_zero, ship_zero]
        for o in lst:
            if o != s:
                if o.r == s.r and nbrs[0] == ship_zero:
                    nbrs[0] = o
                elif o.c == s.c and nbrs[1] == ship_zero:
                    nbrs[1] = o
                if nbrs[0] != ship_zero and nbrs[1] != ship_zero:
                    break
        return nbrs

    def fix_degenerate_case(self):
        eps = math.nextafter(0, 1)
        if len(self.supply) + len(self.demand) - 1 != len(self.matrix_to_list()):
            for r in range(len(self.supply)):
                for c in range(len(self.demand)):
                    if self.matrix[r][c] == ship_zero:
                        dummy = Shipment(eps, self.costs[r][c], r, c)
                        if not self.get_closed_path(dummy):  # Check if path is empty list.
                            self.matrix[r][c] = dummy
                            return

    def print_result(self):
        print(self.filename)
        with open(self.filename, 'r') as f:
            text = f.read()
        print("\n" + text + "\n")
        print(f"Optimal solution for {self.filename}\n")

        total_costs = 0.0
        for r in range(len(self.supply)):
            for c in range(len(self.demand)):
                s = self.matrix[r][c]
                if s != ship_zero and s.r == r and s.c == c:
                    print(f" {int(s.quantity):3d} ", end="")
                    total_costs += s.quantity * s.cost_per_unit
                else:
                    print("  -  ", end="")
            print()

        print(f"\nTotal costs: {total_costs}\n")


def main():
    filenames = ["input1.txt", "input2.txt", "input3.txt"]
    for filename in filenames:
        t = Transport(filename)
        t.north_west_corner_rule()
        t.stepping_stone()
        t.print_result()


if __name__ == "__main__":
    main()
