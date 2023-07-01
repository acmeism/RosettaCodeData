// A prototype declaration for a function that does not require arguments
function List() {}

List.prototype.push = function() {
  return [].push.apply(this, arguments);
};

List.prototype.pop = function() {
  return [].pop.call(this);
};

var l = new List();
l.push(5);
l.length; // 1
l[0]; 5
l.pop(); // 5
l.length; // 0

// A prototype declaration for a function that utilizes varargs
function List() {
  this.push.apply(this, arguments);
}

List.prototype.push = function() {
  return [].push.apply(this, arguments);
};

List.prototype.pop = function() {
  return [].pop.call(this);
};

var l = new List(5, 10, 15);
l.length; // 3
l[0]; 5
l.pop(); // 15
l.length; // 2
