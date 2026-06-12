from collections import Counter

LIST = ["1a3c52debeffd", "2b6178c97a938stf", "3ycxdb1fgxa2yz"]

print(
    sorted(
        set.intersection(
            *(
                set(char for char, count in counts.items() if count == 1)
                for counts in (Counter(s) for s in LIST)
            )
        )
    )
)
