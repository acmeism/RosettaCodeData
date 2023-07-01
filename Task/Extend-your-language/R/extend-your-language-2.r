for(x in 1:2) for(y in letters[1:2])
{
  print(if2(x == 1, y == "a",
    "both conditions are true",
    x + 99,
    {
      yy <- rep.int(y, 10)
      paste(letters[1:10], yy)
    },
    NULL
  ))
}
