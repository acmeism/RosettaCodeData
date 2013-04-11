repeat i 100 [
    print switch/default 0 compose [
        (mod i 15) ["fizzbuzz"]
        (mod i 3)  ["fizz"]
        (mod i 5)  ["buzz"]
    ][i]
]

; And minimized version:

repeat i 100[j:""if 0 = mod i 3[j:"fizz"]if 0 = mod i 5[j: join j"buzz"]if j =""[j: i]print j]
