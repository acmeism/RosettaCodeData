from datetime import date
from calendar import isleap

def weekday(d):
    days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday",
            "Friday", "Saturday"]
    dooms = [
        [3, 7, 7, 4, 2, 6, 4, 1, 5, 3, 7, 5],
        [4, 1, 7, 4, 2, 6, 4, 1, 5, 3, 7, 5]
    ]

    c = d.year // 100
    r = d.year % 100
    s = r // 12
    t = r % 12
    c_anchor = (5 * (c % 4) + 2) % 7
    doomsday = (s + t + (t // 4) + c_anchor) % 7
    anchorday = dooms[isleap(d.year)][d.month - 1]
    weekday = (doomsday + d.day - anchorday + 7) % 7
    return days[weekday]

dates = [date(*x) for x in
    [(1800, 1, 6), (1875, 3, 29), (1915, 12, 7), (1970, 12, 23),
     (2043, 5, 14), (2077, 2, 12), (2101, 4, 2)]
]

for d in dates:
    tense = "was" if d < date.today() else "is" if d == date.today() else "will be"
    print("{} {} a {}".format(d.strftime("%B %d, %Y"), tense, weekday(d)))
