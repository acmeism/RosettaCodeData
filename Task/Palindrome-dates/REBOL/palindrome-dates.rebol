Rebol [
    title: "Rosetta code: Palindrome dates"
    file:  %Palindrome_dates.r3
    url:   https://rosettacode.org/wiki/Palindrome_dates
]

palindrome-date?: function [
    "Returns true if the date reads the same forwards and backwards in YYYYMMDD format."
    date [date!]
][
    formated: format-datetime date "yyyymmdd"  ;; e.g. 20210112
    did equal? formated reverse copy formated  ;; compare original vs reversed
]

print as-yellow "First 15 palindrome dates after 2020-02-02 are:"
n: 0 date: 2020-2-3  ;; search start date
until [
    if palindrome-date? date [
        ++ n
        printf [-7 ": " <yyyy-mm-dd>] [n date]  ;; print index and date
    ]
    date: date + 1   ;; advance by one day
    n >= 15          ;; stop after finding 15 palindrome dates
]
