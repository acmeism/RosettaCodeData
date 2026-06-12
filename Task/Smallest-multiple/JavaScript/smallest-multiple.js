function gcd_euclid(a, b) {
  if (b === 0) {
    return Math.abs(a);
  } else {
    return gcd_euclid(b, a % b);
  }
}

function lcm_euclid(a, b) {
  return a * b / gcd_euclid(a, b);
}

let arr = [...Array(21).keys()];
arr.shift();
console.log(arr.reduce(lcm_euclid));
