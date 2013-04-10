public static Object[] objArrayConcat(Object[] o1, Object[] o2)
{
  Object[] ret = new Object[o1.length + o2.length];

  System.arraycopy(o1, 0, ret, 0, o1.length);
  System.arraycopy(o2, 0, ret, o1.length, o2.length);

  return ret;
}
