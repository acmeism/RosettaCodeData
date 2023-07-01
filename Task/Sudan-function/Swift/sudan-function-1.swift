//Aamrun, 3rd February 2023

func F(n: Int,x: Int,y: Int) -> Int {
  if (n == 0) {
    return x + y;
  }

  else if (y == 0) {
    return x;
  }

    return F(n: n - 1, x: F(n: n, x: x, y: y - 1), y: F(n: n, x: x, y: y - 1) + y);
}

print("F1(3,3) = " + String(F(n: 1,x: 3,y: 3)));
