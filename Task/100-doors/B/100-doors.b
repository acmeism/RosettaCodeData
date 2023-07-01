main()
{
  auto doors[100]; /* != 0 means open */
  auto pass, door;

  door = 0;
  while( door<100 ) doors[door++] = 0;

  pass = 0;
  while( pass<100 )
  {
    door = pass;
    while( door<100 )
    {
      doors[door] = !doors[door];
      door =+ pass+1;
    }
    ++pass;
  }

  door = 0;
  while( door<100 )
  {
    printf("door #%d is %s.*n", door+1, doors[door] ? "open" : "closed");
    ++door;
  }

  return(0);
}
