function Bottles(count) {
  this.count = count || 99;
}

Bottles.prototype.take = function() {
  var verse = [
    this.count + " bottles of beer on the wall,",
    this.count + " bottles of beer!",
    "Take one down, pass it around",
    (this.count - 1) + " bottles of beer on the wall!"
  ].join("\n");

  console.log(verse);

  this.count--;
};

Bottles.prototype.sing = function() {
  while (this.count) {
    this.take();
  }
};

var bar = new Bottles(99);
bar.sing();
