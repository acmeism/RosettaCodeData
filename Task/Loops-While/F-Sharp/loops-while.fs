let rec loop n = if n > 0 then printf "%d " n; loop (n / 2)
loop 1024
