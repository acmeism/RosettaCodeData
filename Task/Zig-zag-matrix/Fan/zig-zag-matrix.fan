using gfx  // for Point; convenient x/y wrapper

**
** A couple methods for generating a 'zigzag' array like
**
**   0  1  5  6
**   2  4  7 12
**   3  8 11 13
**   9 10 14 15
**
class ZigZag
{
  ** return an n x n array of uninitialized Int
  static Int[][] makeSquareArray(Int n)
  {
    Int[][] grid := Int[][,] {it.size=n}
    n.times |i| { grid[i] = Int[,] {it.size=n} }
    return grid
  }


  Int[][] zig(Int n)
  {
    grid := makeSquareArray(n)

    move := |Int i, Int j->Point|
    { return j < n - 1 ? Point(i <= 0 ? 0 : i-1, j+1) : Point(i+1, j) }
    pt := Point(0,0)
    (n*n).times |i| {
      grid[pt.y][pt.x] = i
      if ((pt.x+pt.y)%2 != 0) pt = move(pt.x,pt.y)
      else {tmp:= move(pt.y,pt.x); pt = Point(tmp.y, tmp.x) }
    }
    return grid
  }

  public static Int[][] zag(Int size)
  {
    data := makeSquareArray(size)

    Int i := 1
    Int j := 1
    for (element:=0; element < size * size; element++)
    {
      data[i - 1][j - 1] = element
      if((i + j) % 2 == 0) {
        // Even stripes
        if (j < size) {
          j++
        } else {
          i += 2
        }
        if (i > 1) {
          i--
        }
      } else {
        // Odd stripes
        if (i < size) {
          i++;
        } else {
          j += 2
        }
        if (j > 1) {
          j--
        }
      }
    }
    return data;
  }

  Void print(Int[][] data)
  {
    data.each |row|
    {
      buf := StrBuf()
      row.each |num|
      {
        buf.add(num.toStr.justr(3))
      }
      echo(buf)
    }
  }

  Void main()
  {
    echo("zig method:")
    print(zig(8))
    echo("\nzag method:")
    print(zag(8))
  }
}
