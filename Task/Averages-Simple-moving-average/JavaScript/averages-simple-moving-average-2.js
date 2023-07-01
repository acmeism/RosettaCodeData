// single-sided
Array.prototype.simpleSMA=function(N) {
return this.map(
  function(el,index, _arr) {
      return _arr.filter(
      function(x2,i2) {
        return i2 <= index && i2 > index - N;
        })
      .reduce(
      function(current, last, index, arr){
        return (current + last);
        })/index || 1;
      });
};

g=[0,1,2,3,4,5,6,7,8,9,10];
console.log(g.simpleSMA(3));
console.log(g.simpleSMA(5));
console.log(g.simpleSMA(g.length));
