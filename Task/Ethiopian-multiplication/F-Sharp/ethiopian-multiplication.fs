let ethopian n m =
    let halve n = n / 2
    let double n = n * 2
    let even n = n % 2 = 0
    let rec loop n m result =
        if n <= 1 then result + m
        else if even n then loop (halve n) (double m) result
        else loop (halve n) (double m) (result + m)
    loop n m 0
