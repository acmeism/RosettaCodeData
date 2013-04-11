var obj = {
  foo: 1,
  bar: function () { return this.foo; }
};
obj.bar(); // returns 1
