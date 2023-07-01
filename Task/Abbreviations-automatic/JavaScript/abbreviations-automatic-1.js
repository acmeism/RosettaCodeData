Array.prototype.hasDoubles = function() {
  let arr = this.slice();
  while (arr.length > 1) {
    let cur = arr.shift();
    if (arr.includes(cur)) return true;
  }
  return false;
}

function getMinAbbrLen(arr) {
  if (arr.length <= 1) return '';
  let testArr = [],
      len = 0, i;
  do {
    len++;
    for (i = 0; i < arr.length; i++)
      testArr[i] = arr[i].substr(0, len);
  } while (testArr.hasDoubles());
  return len;
}

// testing
for (let x = 0; x < list.length; x++) {
  let days = list[x].split(' '),
      l    = getMinAbbrLen(days);
  for (let y = 0; y < days.length; y++)
    days[y] = days[y].substring(0, l);
  document.write(`<p>(${l}): ${days.join('. ')}.</p>`);
}
