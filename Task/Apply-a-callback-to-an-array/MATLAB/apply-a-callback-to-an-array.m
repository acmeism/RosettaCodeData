>> array = [1 2 3 4 5]

array =

     1     2     3     4     5

>> arrayfun(@sin,array)

ans =

  Columns 1 through 4

   0.841470984807897   0.909297426825682   0.141120008059867  -0.756802495307928

  Column 5

  -0.958924274663138

>> cellarray = {1,2,3,4,5}

cellarray =

    [1]    [2]    [3]    [4]    [5]

>> cellfun(@tan,cellarray)

ans =

  Columns 1 through 4

   1.557407724654902  -2.185039863261519  -0.142546543074278   1.157821282349578

  Column 5

  -3.380515006246586
