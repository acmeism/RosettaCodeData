list := [], t := [], result := []

list[1] := [3,4,34,25,9,12,36,56,36]
list[2] := [2,8,81,169,34,55,76,49,7]
list[3] := [75,121,75,144,35,16,46,35]

for i, l in list
    for j, n in l
        if ((s:=Sqrt(n)) = Floor(s))
            t[n, j] := true

for n, obj in t
    for i, v in obj
        result.push(n)
