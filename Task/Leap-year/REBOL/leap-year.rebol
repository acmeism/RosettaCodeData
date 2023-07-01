leap-year?: func [
    {Returns true if the specified year is a leap year; false otherwise.}
    year [date! integer!]
    /local div?
][
    either date? year [year: year/year] [
        if negative? year [throw make error! join [script invalid-arg] year]
    ]
    ; The key numbers are 4, 100, and 400, combined as follows:
    ;   1) If the year is divisible by 4, it’s a leap year.
    ;   2) But, if the year is also divisible by 100, it’s not a leap year.
    ;   3) Double but, if the year is also divisible by 400, it is a leap year.
    div?: func [n] [zero? year // n]
    to logic! any [all [div? 4  not div? 100] div? 400]
]
