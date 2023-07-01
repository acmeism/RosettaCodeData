// range(iMax)
// range(iMin, iMax)
// range(iMin, iMax, dI)
function range() {
  var lngArgs = arguments.length,
    lngMore = lngArgs - 1;

  iMin = lngMore ? arguments[0] : 1;
  iMax = arguments[lngMore ? 1 : 0];
  dI = lngMore > 1 ? arguments[2] : 1;

  return lngArgs ? Array.apply(null, Array(
    Math.floor((iMax - iMin) / dI) + 1
  )).map(function (_, i) {
    return iMin + (dI * i);
  }) : [];
}

console.log(
  range(2, 8, 2).join(', ') + ', who do we appreciate ?'
);
