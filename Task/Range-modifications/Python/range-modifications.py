class Sequence():

    def __init__(self, sequence_string):
        self.ranges = self.to_ranges(sequence_string)
        assert self.ranges == sorted(self.ranges), "Sequence order error"

    def to_ranges(self, txt):
        return [[int(x) for x in r.strip().split('-')]
                for r in txt.strip().split(',') if r]

    def remove(self, rem):
        ranges = self.ranges
        for i, r in enumerate(ranges):
            if r[0] <= rem <= r[1]:
                if r[0] == rem:     # range min
                    if r[1] > rem:
                        r[0] += 1
                    else:
                        del ranges[i]
                elif r[1] == rem:   # range max
                    if r[0] < rem:
                        r[1] -= 1
                    else:
                        del ranges[i]
                else:               # inside, range extremes.
                    r[1], splitrange = rem - 1, [rem + 1, r[1]]
                    ranges.insert(i + 1, splitrange)
                break
            if r[0] > rem:  # Not in sorted list
                break
        return self

    def add(self, add):
        ranges = self.ranges
        for i, r in enumerate(ranges):
            if r[0] <= add <= r[1]:     # already included
                break
            elif r[0] - 1 == add:      # rough extend to here
                r[0] = add
                break
            elif r[1] + 1 == add:      # rough extend to here
                r[1] = add
                break
            elif r[0] > add:      # rough insert here
                ranges.insert(i, [add, add])
                break
        else:
            ranges.append([add, add])
            return self
        return self.consolidate()

    def consolidate(self):
        "Combine overlapping ranges"
        ranges = self.ranges
        for this, that in zip(ranges, ranges[1:]):
            if this[1] + 1 >= that[0]:  # Ranges interract
                if this[1] >= that[1]:  # this covers that
                    this[:], that[:] = [], this
                else:   # that extends this
                    this[:], that[:] = [], [this[0], that[1]]
        ranges[:] = [r for r in ranges if r]
        return self
    def __repr__(self):
        rr = self.ranges
        return ",".join(f"{r[0]}-{r[1]}" for r in rr)

def demo(opp_txt):
    by_line = opp_txt.strip().split('\n')
    start = by_line.pop(0)
    ex = Sequence(start.strip().split()[-1][1:-1])    # Sequence("1-3,5-5")
    lines = [line.strip().split() for line in by_line]
    opps = [((ex.add if word[0] == "add" else ex.remove), int(word[1]))
            for word in lines]
    print(f"Start: \"{ex}\"")
    for op, val in opps:
        print(f"    {op.__name__:>6} {val:2} => {op(val)}")
    print()

if __name__ == '__main__':
    demo("""
        Start with ""
            add 77
            add 79
            add 78
            remove 77
            remove 78
            remove 79
         """)
    demo("""
        Start with "1-3,5-5"
            add 1
            remove 4
            add 7
            add 8
            add 6
            remove 7
         """)
    demo("""
        Start with "1-5,10-25,27-30"
            add 26
            add 9
            add 7
            remove 26
            remove 9
            remove 7
        """)
