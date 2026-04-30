def move (n, from, to, via)
  if n == 1
    printf "Move from %s to %s.\n", from, to
  else
    move n-1, from, via, to
    printf "Move from %s to %s.\n", from, to
    move n-1, via, to, from
  end
end

move 3, "1", "3", "2"
