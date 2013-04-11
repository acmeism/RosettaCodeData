String lcsRecursion(String a, String b) {
  int aLen = a.length;
  int bLen = b.length;

  if (aLen == 0 || bLen == 0) {
    return "";
  } else if (a.charCodeAt(aLen-1) == b.charCodeAt(bLen-1)) {
    return lcsRecursion(a.substring(0,aLen-1),b.substring(0,bLen-1))
    + a[aLen-1];
  } else {
    var x = lcsRecursion(a, b.substring(0,bLen-1));
    var y = lcsRecursion(a.substring(0,aLen-1), b);
    return (x.length > y.length) ? x : y;
  }
}

String lcsDynamic(String a, String b) {
  List<List<int>> lengths = new List<List<int>>(a.length+1);
  for(int i=0; i<lengths.length; i++) {
    lengths[i] = [];
    lengths[i].insertRange(0, b.length+1, 0);
  }

  // row 0 and column 0 are initialized to 0 already
  for (int i = 0; i < a.length; i++) {
    for (int j = 0; j < b.length; j++) {
      if (a.charCodeAt(i) == b.charCodeAt(j)) {
        lengths[i+1][j+1] = lengths[i][j] + 1;
      } else {
        lengths[i+1][j+1] = Math.max(lengths[i+1][j], lengths[i][j+1]);
      }
    }
  }

  // read the substring out from the matrix
  StringBuffer sb = new StringBuffer();
  for (int x = a.length, y = b.length; x!=0 && y!=0;) {
    if (lengths[x][y] == lengths[x-1][y]) {
      x--;
    } else if (lengths[x][y] == lengths[x][y-1]) {
      y--;
    } else {
      assert(a.charCodeAt(x-1) == b.charCodeAt(y-1));
      sb.add(a[x-1]);
      x--;
      y--;
    }
  }

  // reverse String
  var l = sb.toString().splitChars();
  StringBuffer sb2 = new StringBuffer();
  for(int i=l.length-1; i>=0; i--) {
    sb2.add(l[i]);
  }

  return sb2.toString();
}

void main() {
  print("lcsDynamic('1234', '1224533324') = " + lcsDynamic("1234", "1224533324"));
  print("lcsDynamic('thisisatest', 'testing123testing') = " + lcsDynamic("thisisatest", "testing123testing"));
  print("lcsDynamic('', 'x') = " + lcsDynamic("", "x"));
  print("lcsDynamic('x', 'x') = " + lcsDynamic("x", "x"));
  print("");
  print("lcsRecursion('1234', '1224533324') = " + lcsRecursion("1234", "1224533324"));
  print("lcsRecursion('thisisatest', 'testing123testing') = " + lcsRecursion("thisisatest", "testing123testing"));
  print("lcsRecursion('', 'x') = " + lcsRecursion("", "x"));
  print("lcsRecursion('x', 'x') = " + lcsRecursion("x", "x"));
}
