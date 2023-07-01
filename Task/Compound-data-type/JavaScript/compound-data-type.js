//using object literal syntax
var point = {x : 1, y : 2};

//using constructor
var Point = function (x, y) {
  this.x = x;
  this.y = y;
};
point = new Point(1, 2);

//using ES6 class syntax
class Point {
  constructor(x, y) {
    this.x = x;
    this.y = y;
  }
}
point = new Point(1, 2);
