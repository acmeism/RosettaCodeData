{ 1 2 3 }
{
  [ "The initial array: " write . ]
  [ [ 42 1 ] dip set-nth ]
  [ "Modified array: " write . ]
  [ "The element we modified: " write [ 1 ] dip nth . ]
} cleave
