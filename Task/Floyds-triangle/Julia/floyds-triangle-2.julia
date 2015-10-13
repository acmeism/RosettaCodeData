floyd(n) =
  pprint([join([lpad(j+binomial(i,2), (j==1?0:1)+ndigits(j+binomial(n,2)), " ")
               for j=1:i])
         for i=1:n])

pprint(matrix) = for i = 1:size(matrix,1) println(join(matrix[i,:])) end
