BEGIN {
  for(i=1; i <= 100; i++)
  {
    doors[i] = 0 # close the doors
  }
  for(i=1; i <= 100; i++)
  {
    for(j=i; j <= 100; j += i)
    {
      doors[j] = (doors[j]+1) % 2
    }
  }
  for(i=1; i <= 100; i++)
  {
    print i, doors[i] ? "open" : "close"
  }
}
