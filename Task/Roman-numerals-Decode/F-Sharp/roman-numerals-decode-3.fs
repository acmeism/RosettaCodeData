let tests = ["MCMXC"; "MMVIII"; "MDCLXVII"; "MMMCLIX"; "MCMLXXVII"; "MMX"]
for test in tests do Printf.printf "%s: %d\n" test (decimal_of_roman test)
;;
