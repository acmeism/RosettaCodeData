Array.prototype.bubblesort = function() {
  var done = false;
  while (! done) {
    done = true;
    for (var i = 1; i < this.length; i++) {
      if (this[i - 1] > this[i]) {
        done = false;
        var tmp = this[i - 1];
        this[i - 1] = this[i];
        this[i] = tmp;
      }
    }
  }
  return this;
}
