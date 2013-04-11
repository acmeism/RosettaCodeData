var freq =  from c in str
            where char.IsLetter(c)
            orderby c
            group c by c into g
            select g.Key + ":" + g.Count();

foreach(var g in freq)
    Console.WriteLine(g);
