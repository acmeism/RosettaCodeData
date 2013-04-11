int(0..1) order_array(array a, array b)
{
  if (!sizeof(a)) return true;
  if (!sizeof(b)) return false;
  if (a[0] == b[0])
    return order_array(a[1..], b[1..]);
  return a[0] < b[0];
}
