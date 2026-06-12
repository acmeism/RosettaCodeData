Red[]

foreach word read/lines %unixdict.txt [
    if all [
        greater? length? word 5
        equal? take/part copy word 3 take/part/last copy word 3
    ][
        print word
    ]
]
