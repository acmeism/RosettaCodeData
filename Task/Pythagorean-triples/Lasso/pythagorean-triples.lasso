// Brute Force: Too slow for large numbers
define num_pythagorean_triples(max_perimeter::integer) => {
   local(max_b) = (#max_perimeter / 3)*2

   return (
      with a in 1 to (#max_b - 1)
      sum integer(
         with b in (#a + 1) to #max_b
         let c = math_sqrt(#a*#a + #b*#b)
         where #c == integer(#c)
         where #c > #b
         where (#a+#b+#c) <= #max_perimeter
         sum 1
      )
   )
}
stdout(`Number of Pythagorean Triples in a Perimeter of 100: `)
stdoutnl(num_pythagorean_triples(100))
