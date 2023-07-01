function isUnprimable(num) {
  if (num < 100 || num.isPrime()) return false;
  let arr = num.toString().split('');
  for (let x = 0; x < arr.length; x++) {
    let lft = arr.slice(0, x),
        rgt = arr.slice(x + 1);
    for (let y = 0; y < 10; y++) {
      let test = lft.join('') + y.toString() + rgt.join('');
      if (parseInt(test).isPrime()) return false;
    }
  }
  return true;
}
