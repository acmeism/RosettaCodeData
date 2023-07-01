: euler(f, y, a, b, h)
| t |
   a b h step: t [
      System.Out t <<wjp(6, JUSTIFY_RIGHT, 3) " : " << y << cr
      t y f perform h * y + ->y
      ] ;
