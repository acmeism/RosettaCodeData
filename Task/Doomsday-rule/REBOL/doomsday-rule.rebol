Rebol [
    title: "Rosetta code: Doomsday rule"
    file:  %Doomsday_rule.r3
    url:   https://rosettacode.org/wiki/Doomsday_rule
]

is-leap-year?: func [
    "Returns true if the given year is a leap year"
    year [integer!]
][
    did any [
        all [year % 4 = 0  year % 100 != 0]  ;; divisible by 4 but not 100
        year % 400 = 0                       ;; or divisible by 400
    ]
]

doom-weekday: function/with [
    "Returns the day name for a given date using the Doomsday algorithm"
    d [date!]
][
    y: d/year                        ;; year
    m: d/month                       ;; month
    c: y // 100                      ;; century
    r: y %  100                      ;; year within century
    s: r // 12                       ;; 12-year periods
    t: r % 12                        ;; remainder
    c-anchor: (5 * (c % 4) + 2) % 7  ;; century anchor day
    doomsday: (s + t + (t // 4) + c-anchor) % 7
    anchor: dooms/(is-leap-year? y)/:m
    day-names/((doomsday + d/day - anchor + 7) % 7 + 1)
][
    day-names: ["Sunday" "Monday" "Tuesday" "Wednesday" "Thursday" "Friday" "Saturday"]
    dooms: #[
        #(false) [3 7 7 4 2 6 4 1 5 3 7 5]  ;; common year
        #(true)  [4 1 7 4 2 6 4 1 5 3 7 5]  ;; leap year
    ]
]

print as-yellow "Days of week given by Doomsday rule:"
today: now/date
foreach date [
    1800-01-06  1875-03-29  1915-12-07  1970-12-23
    2043-05-14  2077-02-12  2101-04-02
][
    print [
        "💀" as-red date
        case [
            date < today  ["was"    ]
            date = today  ["is"     ]
            'else         ["will be"]
        ]
        "a" as-green doom-weekday date
    ]
]
