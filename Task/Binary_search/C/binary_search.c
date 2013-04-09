/* http://www.solipsys.co.uk/b_search/spec.htm */
typedef int Object;

int cmpObject(Object* pa, Object *pb)
{
  Object a = *pa;
  Object b = *pb;
  if (a < b) return -1;
  if (a == b) return 0;
  if (a > b) return 1;
  assert(0);
}

int bsearch(Object Array[], int n, Object *KeyPtr,
	    int (*cmp)(Object *, Object *),
            int NotFound)
{
  unsigned left = 1, right = n; /* `unsigned' to avoid overflow in `(left + right)/2' */

  if ( ! (Array && n > 0 && KeyPtr && cmp))
    return NotFound; /* invalid input or empty array */

  while (left < right)
  {
    /* invariant: a[left] <= *KeyPtr <= a[right] or *KeyPtr not in Array */
    unsigned m = (left  +  right) / 2; /*NOTE: *intentionally* truncate for odd sum */

    if (cmp(Array + m, KeyPtr) < 0)
      left = m + 1;       /* a[m] < *KeyPtr <= a[right] or *KeyPtr not in Array */
    else
      /* assert(right != m) or infinite loop possible */
      right = m;          /* a[left] <= *KeyPtr <= a[m] or *KeyPtr not in Array */
  }
  /* assert(left == right) */
  return (cmp(Array + right, KeyPtr) == 0) ? right : NotFound;
}
