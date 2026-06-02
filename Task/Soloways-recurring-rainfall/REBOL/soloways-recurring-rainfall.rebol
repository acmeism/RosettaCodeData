Rebol [
    title: "Rosetta code: Soloway's recurring rainfall"
    file:  %Soloway's_recurring_rainfall.r3
    url:   https://rosettacode.org/wiki/Soloway%27s_recurring_rainfall
]

rainfall-average: function[
    "Reads integers from the user, printing a running average after each entry."
    end-value [integer!] "sentinel value that terminates input"
][
    sum: count: 0
    forever [
        n: ask ["Enter rainfall (integer) or" as-green end-value "to quit: "]
        try/with [n: to integer! n][
            print as-red "Invalid input, please enter an integer."
            continue
        ]
        if n = end-value [break]
        sum:   sum + n
        count: count + 1
        print ["New average:" as-green sum / count]
    ]
    sum
]

rainfall-average 99999
