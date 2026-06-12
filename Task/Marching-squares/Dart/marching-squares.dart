import 'dart:io';

class PerimeterDetection {
  // Direction constants
  static const int E = 0;
  static const int N = 1;
  static const int W = 2;
  static const int S = 3;

  // X generates coordinate pairs for a grid of given dimensions
  static List<List<int>> X(int a, int b) {
    List<List<int>> c = [];
    for (int aa = 0; aa <= a; aa++) {
      for (int bb = 0; bb <= b; bb++) {
        c.add([aa, bb]);
      }
    }
    return c;
  }

  // any checks if any element in the array equals val
  static bool any(List<int> arr, int val) {
    return arr.contains(val);
  }

  // Result class to return multiple values from identifyPerimeter
  static PerimeterResult identifyPerimeter(List<List<int>> data) {
    for (List<int> coords in X(data[0].length - 1, data.length - 1)) {
      int x = coords[0];
      int y = coords[1];

      if (y < data.length && x < data[0].length && data[y][x] != 0) {
        StringBuffer path = StringBuffer();
        int cx = x, cy = y;
        int d = 0, p = 0;

        do {
          int mask = 0;

          List<List<int>> vals = [[0, 0, 1], [1, 0, 2], [0, 1, 4], [1, 1, 8]];
          for (List<int> val in vals) {
            int dx = val[0], dy = val[1], b = val[2];
            int mx = cx + dx, my = cy + dy;

            if (mx > 0 && my > 0 && my - 1 < data.length &&
                mx - 1 < data[0].length && data[my - 1][mx - 1] != 0) {
              mask += b;
            }
          }

          if (any([1, 5, 13], mask)) {
            d = N;
          }
          if (any([2, 3, 7], mask)) {
            d = E;
          }
          if (any([4, 12, 14], mask)) {
            d = W;
          }
          if (any([8, 10, 11], mask)) {
            d = S;
          }
          if (mask == 6) {
            if (p == N) {
              d = W;
            } else {
              d = E;
            }
          }
          if (mask == 9) {
            if (p == E) {
              d = N;
            } else {
              d = S;
            }
          }

          List<String> dirChars = ['E', 'N', 'W', 'S'];
          path.write(dirChars[d]);
          p = d;

          List<int> dxVals = [1, 0, -1, 0];
          List<int> dyVals = [0, -1, 0, 1];
          cx += dxVals[d];
          cy += dyVals[d];

        } while (!(cx == x && cy == y));

        return PerimeterResult(x, -y, path.toString());
      }
    }

    print("That did not work out...");
    exit(1);
  }
}

// Result class to return multiple values from identifyPerimeter
class PerimeterResult {
  final int x;
  final int y;
  final String path;

  PerimeterResult(this.x, this.y, this.path);
}

void main() {
  List<List<int>> M = [
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 1, 1, 0],
    [0, 0, 1, 1, 0],
    [0, 0, 0, 1, 0],
    [0, 0, 0, 0, 0]
  ];

  PerimeterResult result = PerimeterDetection.identifyPerimeter(M);
  print('X: ${result.x}, Y: ${result.y}, Path: ${result.path}');
}
