  function sattoloCycle(items) {
    for (var i = items.length-1; i > 0; i--) {
        var j = Math.floor(Math.random() * i);
        var tmp = items[i];
        items[i] = items[j];
        items[j] = tmp;
    }
  }

  //  ES6
  const sattolo = (arr) => {
    let i, j, len = arr.length - 1;
    for (i = len; i > 0; i--) {
        j = Math.floor(Math.random() * i);
        [arr[i], arr[j]] = [arr[j], arr[i]];
    }
    return arr;
  }

