fn f {
   printf 'scale=3; sqrt(sqrt(%s^2)) + 5.0 * %s ^ 3 \n' $1 $1 | bc
}

count = 11
list = ()
for (idx in `{seq $count}) {
   num = `{read}  # get value from stdin
   list = ($num $list)  # add to list in reverse
}
for (idx in `{seq $count}) {
   x = $list($idx)
   printf 'f(%s) = ' $x
   y = `{f $x}
   if (~ `{printf '%s > 400 \n' $y | bc} 1)
      echo TOO LARGE!
   if not echo $y
}
