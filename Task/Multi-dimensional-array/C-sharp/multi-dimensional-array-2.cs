var array = new int[][] { //Dimensions are inferred
    new [] { 1, 2, 3, 4 },
    new [] { 5, 6, 7, 8, 9, 10 }
}
//Accessing a single element:
array[0][0] = 999;

//To create a 4-dimensional array with all zeroes:
var array = new int[5][][][];
for (int a = 0; a < array.Length; a++) {
    array[a] = new int[4][][];
    for (int b = 0; b < array[a].Length; b++) {
        array[a][b] = new int[3][];
        for (int c = 0; c < array[a][b].Length; c++) {
            array[a][b][c] = new int[2];
        }
    }
}
