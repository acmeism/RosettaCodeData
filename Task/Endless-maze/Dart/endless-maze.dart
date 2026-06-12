import 'dart:io';
import 'dart:math';

void main() {
  int xp = 127, yp = 127, a = 0, na = 0;
  Random rand = Random();
  int f = rand.nextInt(4);
  int d = -1;

  List<int> x = [];
  List<int> y = [];
  List<int> e = [];

  while (true) {
    a = na;
    for (int n = 0; n < na; n++) {
      if (x[n] == xp && y[n] == yp) {
        a = n;
        break;
      }
    }

    if (a == na) {
      na++;
      x.add(xp);
      y.add(yp);
      e.addAll(List.filled(4, 0)); // expand e by 4 elements

      for (int n = 0; n < 4; n++) {
        e[4 * a + n] = rand.nextInt(2);
      }

      for (int n = 0; n < na; n++) {
        if (x[n] == x[a] + 1 && y[n] == y[a]) {
          e[4 * a + 0] = e[4 * n + 2];
        } else if (x[n] == x[a] && y[n] == y[a] + 1) {
          e[4 * a + 1] = e[4 * n + 3];
        } else if (x[n] == x[a] - 1 && y[n] == y[a]) {
          e[4 * a + 2] = e[4 * n + 0];
        } else if (x[n] == x[a] && y[n] == y[a] - 1) {
          e[4 * a + 3] = e[4 * n + 1];
        }
      }
    }

    stdout.write("Paths:");
    if (e[4 * a + (f) % 4] == 1) stdout.write(" ahead");
    if (e[4 * a + (f + 1) % 4] == 1) stdout.write(" right");
    if (e[4 * a + (f + 2) % 4] == 1) stdout.write(" back");
    if (e[4 * a + (f + 3) % 4] == 1) stdout.write(" left");
    print("");

    d = -1;
    while (d < 0) {
      stdout.write("> ");
      String? entry = stdin.readLineSync()?.toLowerCase();

      if (entry == null) continue;

      switch (entry) {
        case "ahead":
          d = f % 4;
          break;
        case "right":
          d = (f + 1) % 4;
          break;
        case "back":
          d = (f + 2) % 4;
          break;
        case "left":
          d = (f + 3) % 4;
          break;
        case "quit":
          return;
        default:
          print("Invalid.");
          d = -1;
          continue;
      }

      switch (d) {
        case 0:
          if (e[4 * a + 0] == 1) {
            xp++;
            f = d;
          } else {
            d = -1;
          }
          break;
        case 1:
          if (e[4 * a + 1] == 1) {
            yp++;
            f = d;
          } else {
            d = -1;
          }
          break;
        case 2:
          if (e[4 * a + 2] == 1) {
            xp--;
            f = d;
          } else {
            d = -1;
          }
          break;
        case 3:
          if (e[4 * a + 3] == 1) {
            yp--;
            f = d;
          } else {
            d = -1;
          }
          break;
      }

      if (d < 0) print("No path.");
    }
  }
}
