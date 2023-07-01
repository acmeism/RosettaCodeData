var array = new int[,] { //Dimensions are inferred
    { 1, 2, 3 },
    { 4, 5, 6}
}
//Accessing a single element:
array[0, 0] = 999;

//To create a 4-dimensional array with all zeroes:
var array = new int[5, 4, 3, 2];
