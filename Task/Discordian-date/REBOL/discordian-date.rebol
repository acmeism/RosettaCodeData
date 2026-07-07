Rebol [
    title: "Rosetta code: Discordian date"
    file:  %Discordian_date.r3
    url:   https://rosettacode.org/wiki/Discordian_date
]

seasons:  ["Chaos" "Discord" "Confusion" "Bureaucracy" "The Aftermath"]
weekdays: ["Sweetmorn" "Boomtime" "Pungenday" "Prickle-Prickle" "Setting Orange"]
apostles: ["Mungday" "Mojoday" "Syaday" "Zaraday" "Maladay"]
holidays: ["Chaoflux" "Discoflux" "Confuflux" "Bureflux" "Afflux"]

leap-year?: function [
    "Return true if year is a leap year"
    y [integer!]
][
    either y % 100 = 0 [y % 400 = 0] [y % 4 = 0]
]

day-of-year: function [
    "Return day number (1-365/366) for a given date"
    date [date!]
][
    offsets: [0 31 59 90 120 151 181 212 243 273 304 334]
    doy: date/day + offsets/(date/month)
    if all [date/month > 2  leap-year? date/year] [doy: doy + 1]
    doy
]

ordinal-suffix: function [
    "Return ordinal suffix for a number"
    n [integer!]
][
    switch/default n % 10 [1 ["st"] 2 ["nd"] 3 ["rd"]]["th"]
]

discordian-date: function [
    "Convert a Gregorian date to Discordian calendar string"
    date [date!]
][
    yold:    date/year + 1166
    doy:     day-of-year date
    holiday: none

    if leap-year? date/year [
        case [
            doy = 60 [holiday: "St. Tib's Day"]
            doy > 60 [doy: doy - 1]
        ]
    ]
    doy: doy - 1                   ;; convert to 0-based

    div-day:    doy // 73          ;; season index
    season-day: (doy % 73) + 1     ;; day within season

    if season-day = 5  [holiday: apostles/(div-day + 1)]
    if season-day = 50 [holiday: holidays/(div-day + 1)]

    season:      pick seasons  div-day + 1
    day-of-week: pick weekdays doy % 5 + 1
    suffix:  ordinal-suffix season-day

    result: ajoin [
        day-of-week ", the " season-day suffix
        " day of " season " in the YOLD " yold
    ]
    if holiday [append result rejoin [". Celebrate " holiday "!"]]
    result
]

;; tests
test: function [date expected] [
    result: discordian-date date
    either result = expected [
        print ["OK:" as-green result]
    ][
        print ["FAIL:" as-red result]
        print ["  expected:" expected]
    ]
]

test 2010-07-22 "Pungenday, the 57th day of Confusion in the YOLD 3176"
test 2012-02-28 "Prickle-Prickle, the 59th day of Chaos in the YOLD 3178"
test 2012-02-29 "Setting Orange, the 60th day of Chaos in the YOLD 3178. Celebrate St. Tib's Day!"
test 2012-03-01 "Setting Orange, the 60th day of Chaos in the YOLD 3178"
test 2010-01-05 "Setting Orange, the 5th day of Chaos in the YOLD 3176. Celebrate Mungday!"
test 2011-05-03 "Pungenday, the 50th day of Discord in the YOLD 3177. Celebrate Discoflux!"
test 2015-10-19 "Boomtime, the 73rd day of Bureaucracy in the YOLD 3181"

print [LF as-yellow now/date "is" as-green discordian-date now/date]
