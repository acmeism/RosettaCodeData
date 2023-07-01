do
  let a, b = int Sys.argv.[1], int Sys.argv.[2]
  for str, f in ["+", ( + ); "-", ( - ); "*", ( * ); "/", ( / ); "%", ( % )] do
    printf "%d %s %d = %d\n" a str b (f a b)
