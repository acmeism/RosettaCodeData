##
uses School;

function IsHarshad(n: integer) := n.Divs(n.Digits.Sum);

1.Step.Where(IsHarshad).Take(20).Println;
1.Step.Where(i -> (i > 1000) and IsHarshad(i)).First.Println;
