[compare
  [ [>] ['less than' puts]
    [<] ['greater than' puts]
    [=] ['is equal' puts]
  ] when].

|2 3 compare
 greater than
|3 2 compare
 less than
|2 2 compare
 is equal
