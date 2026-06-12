import math
import random
import time

class SimulatedAnnealingTSP:
    def __init__(self):
        self.dists = self._calc_dists()
        self.dirs = [1, -1, 10, -10, 9, 11, -11, -9]  # all 8 neighbors
        random.seed(time.time_ns())
        self.epsilon=1e-9

    def _calc_dists(self):
        """Calculate distances between all pairs of cities in 10x10 grid"""
        dists = [0.0] * 10000
        for i in range(10000):
            ab = i // 100
            cd = i % 100
            a = ab // 10
            b = ab % 10
            c = cd // 10
            d = cd % 10
            dists[i] = math.hypot(a - c, b - d)
        return dists

    def dist(self, ci, cj):
        """Get distance between cities ci and cj using lookup table"""
        return self.dists[cj * 100 + ci]

    def Es(self, path):
        """Calculate energy (total distance) of path"""
        d = 0.0
        for i in range(len(path) - 1):
            d += self.dist(path[i], path[i + 1])
        return d

    def T(self, k, kmax, kT):
        """Temperature function - decreases to 0"""
        return (1 - k / kmax) * kT

    def dE(self, s, u, v):
        """Calculate change in energy when swapping cities at indices u and v"""
        su, sv = s[u], s[v]

        # old distances
        a = self.dist(s[u - 1], su)
        b = self.dist(s[u + 1], su)
        c = self.dist(s[v - 1], sv)
        d = self.dist(s[v + 1], sv)

        # new distances
        na = self.dist(s[u - 1], sv)
        nb = self.dist(s[u + 1], sv)
        nc = self.dist(s[v - 1], su)
        nd = self.dist(s[v + 1], su)

        if v == u + 1:
            return (na + nd) - (a + d)
        elif u == v + 1:
            return (nc + nb) - (c + b)
        else:
            return (na + nb + nc + nd) - (a + b + c + d)

    def P(self, deltaE, k, kmax, kT):
        """Probability to move from current state to next state"""
        return math.exp(-deltaE / (self.T(k, kmax, kT)+self.epsilon))

    def sa(self, kmax, kT):
        """Simulated annealing algorithm"""
        # Create initial random path
        temp = list(range(1, 100))  # cities 1 to 99
        random.shuffle(temp)

        # Initialize path array (starts and ends at city 0)
        s = [0] * 101
        for i in range(99):
            s[i + 1] = temp[i]

        print(f"kT = {kT}")
        print(f"E(s0) {self.Es(s):.6f}\n")

        Emin = self.Es(s)  # initial energy

        for k in range(kmax + 1):
            if k % (kmax // 10) == 0:
                print(f"k:{k:10d}   T: {self.T(k, kmax, kT):8.4f}   Es: {self.Es(s):8.4f}")

            u = 1 + random.randint(0, 98)  # city index 1 to 99
            cv = s[u] + self.dirs[random.randint(0, 7)]  # neighboring city number

            if cv <= 0 or cv >= 100:  # invalid city
                continue

            if self.dist(s[u], cv) > 5:  # check if true neighbor
                continue

            v = s.index(cv)  # find index of city cv
            deltae = self.dE(s, u, v)

            if deltae < 0 or self.P(deltae, k, kmax, kT) >= random.random():
                # Swap cities at indices u and v
                s[u], s[v] = s[v], s[u]
                Emin += deltae

        print(f"\nE(s_final) {Emin:.6f}")
        print("Path:")

        # Output final path
        for i in range(len(s)):
            if i > 0 and i % 10 == 0:
                print()
            print(f"{s[i]:4d}", end="")
        print()

def main():
    tsp = SimulatedAnnealingTSP()
    tsp.sa(1000000, 1)

if __name__ == "__main__":
    main()
