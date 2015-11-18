var width = Number(prompt("Enter width: "));
var height = Number(prompt("Enter height: "));

//make 2D array
var arr = new Array(height);

for (var i = 0; i < h; i++) {
  arr[i] = new Array(width);
}

//set value of element
a[0][0] = 'foo';
//print value of element
console.log('arr[0][0] = ' + arr[0][0]);

//cleanup array
arr = void(0);
