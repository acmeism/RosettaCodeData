function halve(x)
{
  return int(x/2)
}

function double(x)
{
  return x*2
}

function iseven(x)
{
  return x%2 == 0
}

function ethiopian(plier, plicand)
{
  r = 0
  while(plier >= 1) {
    if ( !iseven(plier) ) {
      r += plicand
    }
    plier = halve(plier)
    plicand = double(plicand)
  }
  return r
}

BEGIN {
  print ethiopian(17, 34)
}
