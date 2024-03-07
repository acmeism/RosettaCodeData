class Zeckendorf {
  int dVal = 0;
  int dLen = 0;

  Zeckendorf(String x) {
    var q = 1;
    var i = x.length - 1;
    dLen = i ~/ 2;
    while (i >= 0) {
      dVal += (x[i].codeUnitAt(0) - '0'.codeUnitAt(0)) * q;
      q *= 2;
      i--;
    }
  }

  void a(int n) {
    var i = n;
    while (true) {
      if (dLen < i) dLen = i;
      var j = (dVal >> (i * 2)) & 3;
      switch (j) {
        case 0:
        case 1:
          return;
        case 2:
          if (((dVal >> ((i + 1) * 2)) & 1) != 1) return;
          dVal += 1 << (i * 2 + 1);
          return;
        case 3:
          dVal &= ~(3 << (i * 2));
          b((i + 1) * 2);
          break;
      }
      i++;
    }
  }

  void b(int pos) {
    if (pos == 0) {
      this.increment();
      return;
    }
    if (((dVal >> pos) & 1) == 0) {
      dVal += 1 << pos;
      a(pos ~/ 2);
      if (pos > 1) a(pos ~/ 2 - 1);
    } else {
      dVal &= ~(1 << pos);
      b(pos + 1);
      b(pos - (pos > 1 ? 2 : 1));
    }
  }

  void c(int pos) {
    if (((dVal >> pos) & 1) == 1) {
      dVal &= ~(1 << pos);
      return;
    }
    c(pos + 1);
    if (pos > 0)
      b(pos - 1);
    else
      this.increment();
  }

  Zeckendorf increment() {
    dVal += 1;
    a(0);
    return this;
  }

  void operator + (Zeckendorf other) {
    for (var gn = 0; gn < (other.dLen + 1) * 2; gn++) {
      if (((other.dVal >> gn) & 1) == 1) b(gn);
    }
  }

  void operator - (Zeckendorf other) {
    for (var gn = 0; gn < (other.dLen + 1) * 2; gn++) {
        if (((other.dVal >> gn) & 1) == 1) c(gn);
    }
    while (dLen > 0 && (((dVal >> dLen * 2) & 3) == 0)) dLen--;
  }


  void operator * (Zeckendorf other) {
    var na = other.copy();
    var nb = other.copy();
    Zeckendorf nt;
    var nr = Zeckendorf("0");
    for (var i = 0; i <= (dLen + 1) * 2; i++) {
      if (((dVal >> i) & 1) > 0) nr + nb;
      nt = nb.copy();
      nb + na;
      na = nt.copy();
    }
    dVal = nr.dVal;
    dLen = nr.dLen;
  }

  int compareTo(Zeckendorf other) {
    return dVal.compareTo(other.dVal);
  }

  @override
  String toString() {
    if (dVal == 0) return "0";
    var sb = StringBuffer(dig1[(dVal >> (dLen * 2)) & 3]);
    for (var i = dLen - 1; i >= 0; i--) {
      sb.write(dig[(dVal >> (i * 2)) & 3]);
    }
    return sb.toString();
  }

  Zeckendorf copy() {
    var z = Zeckendorf("0");
    z.dVal = dVal;
    z.dLen = dLen;
    return z;
  }

  static final List<String> dig = ["00", "01", "10"];
  static final List<String> dig1 = ["", "1", "10"];
}

void main() {
  print("Addition:");
  var g = Zeckendorf("10");
  g + Zeckendorf("10");
  print(g);
  g + Zeckendorf("10");
  print(g);
  g + Zeckendorf("1001");
  print(g);
  g + Zeckendorf("1000");
  print(g);
  g + Zeckendorf("10101");
  print(g);

  print("\nSubtraction:");
  g = Zeckendorf("1000");
  g - Zeckendorf("101");
  print(g);
  g = Zeckendorf("10101010");
  g - Zeckendorf("1010101");
  print(g);

  print("\nMultiplication:");
  g = Zeckendorf("1001");
  g * Zeckendorf("101");
  print(g);
  g = Zeckendorf("101010");
  g + Zeckendorf("101");
  print(g);
}
