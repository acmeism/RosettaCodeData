void theGameName(String nombre) {
  String x = nombre.toLowerCase();
  x = x[0].toUpperCase() + x.substring(1);
  String x0 = x[0].toUpperCase();

  String y;
  if (x0 == 'A' || x0 == 'E' || x0 == 'I' || x0 == 'O' || x0 == 'U') {
    y = x.toLowerCase();
  } else {
    y = x.substring(1);
  }

  String b = 'b' + y;
  String f = 'f' + y;
  String m = 'm' + y;

  switch (x0) {
    case 'B':
      b = y;
      break;
    case 'F':
      f = y;
      break;
    case 'M':
      m = y;
      break;
  }

  print('$x, $x, bo-$b');
  print('Banana-fana fo-$f');
  print('Fee-fi-mo-$m');
  print('$x!\n');
}

void main() {
  List<String> listanombres = ['Gary', 'Earl', 'Billy', 'Felix', 'Mary', 'Steve'];
  for (String nombre in listanombres) {
    theGameName(nombre);
  }
}
