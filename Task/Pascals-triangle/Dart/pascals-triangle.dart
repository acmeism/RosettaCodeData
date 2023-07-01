import 'dart:io';

pascal(n) {
  if(n<=0) print("Not defined");

  else if(n==1) print(1);

  else {
    List<List<int>> matrix = new List<List<int>>();
    matrix.add(new List<int>());
    matrix.add(new List<int>());
    matrix[0].add(1);
    matrix[1].add(1);
    matrix[1].add(1);
    for (var i = 2; i < n; i++) {
      List<int> list = new List<int>();
      list.add(1);
      for (var j = 1; j<i; j++) {
        list.add(matrix[i-1][j-1]+matrix[i-1][j]);
      }
      list.add(1);
      matrix.add(list);
    }
    for(var i=0; i<n; i++) {
      for(var j=0; j<=i; j++) {
        stdout.write(matrix[i][j]);
        stdout.write(' ');
      }
      stdout.write('\n');
    }
  }
}

void main() {
  pascal(0);
  pascal(1);
  pascal(3);
  pascal(6);
}
