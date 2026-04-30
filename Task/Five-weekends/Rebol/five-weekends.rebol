Rebol [
    title: "Rosetta code: Five weekends"
    file:  %Five_weekends.r3
    url:   https://rosettacode.org/wiki/Five_weekends
]

five-weekends: function/with [
    "Show all months that have five full weekends."
    start [integer!] "Start year"
    end   [integer!] "End year"
][
    boring-years: total-fw-months: awesome-years: 0
    for year start end 1 [
        fw-months: clear []
        ;; A month has five weekends when its first day is a Saturday (weekday 7)
        foreach month long-months [
            if 1 = get-day year month 1 6 [
                ++ total-fw-months
                append fw-months month-names/:month
            ]
        ]
        prin  ajoin [as-yellow year ": "]
        print switch count: length? fw-months [
            0 [
                ++ boring-years
                as-red "Boring year!"
            ]
            1 [
                ajoin ["1 month:  " fw-months]
            ]
            2 [
                ++ awesome-years
                ajoin [as-green count " months: " ajoin/with fw-months ", "]
            ]
        ]
    ]
    print-horizontal-line
    print ["Total five-weekend months:               " total-fw-months]
    print ["Total years with no five-weekend months: " boring-years ]
    print ["Total years with 2+ five-weekend months: " awesome-years]
][
    ;; Return the day-of-month for the Nth weekday in a given month,
    ;; or NONE if that occurrence falls outside the month.
    get-day: function [
        year     [integer!]
        month    [integer!]
        week     [integer!]
        weekday  [integer!]
    ][
        date: to-date reduce [1 month year] ; first-of-month
        ;; Rebol weekday is Mon=1 .. Sun=7; shift to Sun=1 .. Sat=7
        weekday-1st: (date/weekday + 1) % 7
        ;; Days from the 1st to the target weekday in the requested week
        offset: (week - 1) * 7 + (weekday - weekday-1st)
        target-date: date + offset
        ;; Return the day number only if it still falls within the same month or none
        if target-date/month = month [target-date/day]
    ]
    month-names: system/locale/months
    ;; Months with 31 days are the only ones that can hold five full weekends
    long-months: [1 3 5 7 8 10 12]
]

five-weekends 1900 2100
