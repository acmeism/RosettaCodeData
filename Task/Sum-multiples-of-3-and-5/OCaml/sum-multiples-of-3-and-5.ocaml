let sum_mults n =
        let sum = ref 0 in
        for i = 3 to (n - 1) do
                if (i mod 3) = 0 || (i mod 5) = 0 then
                        sum := !sum + i;
        done;
        !sum;;

print_endline (string_of_int (sum_mults 1000));;
