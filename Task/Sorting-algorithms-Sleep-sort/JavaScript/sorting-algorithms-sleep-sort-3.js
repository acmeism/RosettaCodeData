Array.prototype.sleepSort = function(callback) {
  const res = [];
  for (let n of this)
    setTimeout(() => {
      res.push(n);
      if (this.length === res.length)
        callback(res);
    }, n + 1);
  return res;
};

[1, 9, 8, 7, 6, 5, 3, 4, 5, 2, 0].sleepSort(console.log);
// [ 1, 0, 2, 3, 4, 5, 5, 6, 7, 8, 9 ]
