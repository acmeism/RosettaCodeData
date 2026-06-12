// Days between dates: Nigel Galloway. June 3rd., 2021
let n,g=System.DateTime.Parse("1792-9-22"),System.DateTime.Parse("1805-12-31")
printfn "There are %d days between %d-%d-%d and %d-%d-%d" (g-n).Days n.Year n.Month n.Day g.Year g.Month g.Day
