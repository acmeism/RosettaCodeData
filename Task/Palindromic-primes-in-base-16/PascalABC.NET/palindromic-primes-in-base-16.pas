##
uses School;

1.step.Where(n -> n.IsPrime)
      .TakeWhile(p -> p < 500)
      .Select(p -> p.ToString('X'))
      .Where(s -> s = s[::-1])
      .Println;
