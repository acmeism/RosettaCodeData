function median(arr) {
  let mid = Math.floor(arr.length / 2);
  return (arr.length % 2 == 0) ? (arr[mid-1] + arr[mid]) / 2 : arr[mid];
}

Array.prototype.fiveNums = function() {
  this.sort(function(a, b) { return a - b} );
  let mid = Math.floor(this.length / 2),
      loQ = (this.length % 2 == 0) ? this.slice(0, mid) : this.slice(0, mid+1),
      hiQ = this.slice(mid);
  return [ this[0],
           median(loQ),
           median(this),
           median(hiQ),
           this[this.length-1] ];
}

// testing
let test = [15, 6, 42, 41, 7, 36, 49, 40, 39, 47, 43];
console.log( test.fiveNums() );

test = [0, 0, 1, 2, 63, 61, 27, 13];
console.log( test.fiveNums() );

test = [ 0.14082834,  0.09748790,  1.73131507,  0.87636009, -1.95059594,
         0.73438555, -0.03035726,  1.46675970, -0.74621349, -0.72588772,
         0.63905160,  0.61501527, -0.98983780, -1.00447874, -0.62759469,
         0.66206163,  1.04312009, -0.10305385,  0.75775634,  0.32566578];
console.log( test.fiveNums() );
