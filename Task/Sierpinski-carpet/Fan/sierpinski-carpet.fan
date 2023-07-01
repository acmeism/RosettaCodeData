**
** Generates a square Sierpinski gasket
**
class SierpinskiCarpet
{
  public static Bool inCarpet(Int x, Int y){
    while(x!=0 && y!=0){
      if (x % 3 == 1 && y % 3 == 1)
        return false;
      x /= 3;
      y /= 3;
    }
    return true;
  }

  static Int pow(Int n, Int exp)
  {
    rslt := 1
    exp.times { rslt *= n }
    return rslt
  }

  public static Void carpet(Int n){
    for(i := 0; i < pow(3, n); i++){
      buf := StrBuf()
      for(j := 0; j < pow(3, n); j++){
        if( inCarpet(i, j))
          buf.add("*");
        else
          buf.add(" ");
      }
      echo(buf);
    }
  }

  Void main()
  {
    carpet(4)
  }
}
