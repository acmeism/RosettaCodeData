##
(1..5000).Where(x -> x = x.ToString.Select(c -> (if c = '0' then 0 else c.ToDigit ** c.ToDigit)).Sum).Println;
