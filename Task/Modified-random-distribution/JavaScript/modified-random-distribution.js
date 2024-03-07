function modifier(x) { return (x < .5 ? -1 : +1)*(2*(x-.5)) }

function random(m) {
  let random1, random2;
  while (true) {
    random1 = Math.random();
    random2 = Math.random();
    if (random2 < m(random1)) {
      return random1;
    }
  }
}

const N = 10000;
const bins = 20;
var numbers = [];
for (i=0;i<N;i++) {
  let number = random(modifier);
  numbers.push(number);
}

const delta = 1.0/bins;
var count = 0;
for (ceil=delta; ceil<1.0+delta; ceil+=delta) {
  for (n of numbers) {
    if ((n < ceil) && (ceil - delta <= n)) {
      count++;
    }
  }
  let width = count/N * 80;
  let bar = '';

  for (i = 0; i<width; i++) bar+='#';
  console.log(bar);
  count = 0;
}
