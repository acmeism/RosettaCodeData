Red[]

foreach word read/lines %unixdict.txt [
    if all [11 < length? word find word "the"] [print word]
]
