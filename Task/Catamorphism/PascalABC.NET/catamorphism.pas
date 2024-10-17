##
(1..5).Aggregate((a, b) -> a + b).Println;
(1..5).Aggregate((a, b) -> a * b).Println;
(1..5).Aggregate((a, b) -> a - b).Println;
(1..5).Aggregate((a, b) -> min(a, b)).Println;
(1..5).Aggregate((a, b) -> max(a, b)).Println;
(1..5).Aggregate('', (a, b) -> a.tostring + b.tostring).Println;
