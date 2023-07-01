/**
 * This method will use ethiopian styled multiplication.
 * @param a Any non-negative integer.
 * @param b Any integer.
 * @result a multiplied by b
 */
public static int ethiopianMultiply(int a, int b) {
  if(a==0 || b==0) {
    return 0;
  }
  int result = 0;
  while(a>=1) {
    if(!isEven(a)) {
      result+=b;
    }
    b = doubleInt(b);
    a = halveInt(a);
  }
  return result;
}

/**
 * This method is an improved version that will use
 * ethiopian styled multiplication, and also
 * supports negative parameters.
 * @param a Any integer.
 * @param b Any integer.
 * @result a multiplied by b
 */
public static int ethiopianMultiplyWithImprovement(int a, int b) {
  if(a==0 || b==0) {
    return 0;
  }
  if(a<0) {
    a=-a;
    b=-b;
  } else if(b>0 && a>b) {
    int tmp = a;
    a = b;
    b = tmp;
  }
  int result = 0;
  while(a>=1) {
    if(!isEven(a)) {
      result+=b;
    }
    b = doubleInt(b);
    a = halveInt(a);
  }
  return result;
}
