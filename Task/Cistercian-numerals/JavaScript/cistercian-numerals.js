// html
document.write(`
  <p><input id="num" type="number" min="0" max="9999" value="0" onchange="showCist()"></p>
  <p><canvas id="cist" width="200" height="300"></canvas></p>
  <p> <!-- EXAMPLES (can be deleted for normal use) -->
    <button onclick="set(0)">0</button>
    <button onclick="set(1)">1</button>
    <button onclick="set(20)">20</button>
    <button onclick="set(300)">300</button>
    <button onclick="set(4000)">4000</button>
    <button onclick="set(5555)">5555</button>
    <button onclick="set(6789)">6789</button>
    <button onclick="set(Math.floor(Math.random()*1e4))">Random</button>
  </p>
`);

// to show given examples
// can be deleted for normal use
function set(num) {
  document.getElementById('num').value = num;
  showCist();
}

const SW = 10; // stroke width
let canvas = document.getElementById('cist'),
    cx = canvas.getContext('2d');

function showCist() {
  // reset canvas
  cx.clearRect(0, 0, canvas.width, canvas.height);
  cx.lineWidth = SW;
  cx.beginPath();
  cx.moveTo(100, 0+.5*SW);
  cx.lineTo(100, 300-.5*SW);
  cx.stroke();

  let num = document.getElementById('num').value;
  while (num.length < 4) num = '0' + num;  // fills leading zeros to $num

  /***********************\
  |        POINTS:        |
  | ********************* |
  |                       |
  |     a --- b --- c     |
  |     |     |     |     |
  |     d --- e --- f     |
  |     |     |     |     |
  |     g --- h --- i     |
  |     |     |     |     |
  |     j --- k --- l     |
  |                       |
  \***********************/
  let
  a = [0+SW,   0+SW],   b = [100,   0+SW],   c = [200-SW,   0+SW],
  d = [0+SW,    100],   e = [100,    100],   f = [200-SW,    100],
  g = [0+SW,    200],   h = [100,    200],   i = [200-SW,    200],
  j = [0+SW, 300-SW],   k = [100, 300-SW],   l = [200-SW, 300-SW];

  function draw() {
    let x = 1;
    cx.beginPath();
    cx.moveTo(arguments[0][0], arguments[0][1]);
    while (x < arguments.length) {
      cx.lineTo(arguments[x][0], arguments[x][1]);
      x++;
    }
    cx.stroke();
  }

  // 1000s
  switch (num[0]) {
    case '1': draw(j, k);       break;       case '2': draw(g, h);    break;
    case '3': draw(g, k);       break;       case '4': draw(j, h);    break;
    case '5': draw(k, j, h);    break;       case '6': draw(g, j);    break;
    case '7': draw(g, j, k);    break;       case '8': draw(j, g, h); break;
    case '9': draw(h, g, j, k); break;
  }
  // 100s
  switch (num[1]) {
    case '1': draw(k, l);       break;       case '2': draw(h, i);    break;
    case '3': draw(k, i);       break;       case '4': draw(h, l);    break;
    case '5': draw(h, l, k);    break;       case '6': draw(i, l);    break;
    case '7': draw(k, l, i);    break;       case '8': draw(h, i, l); break;
    case '9': draw(h, i, l, k); break;
  }
  // 10s
  switch (num[2]) {
    case '1': draw(a, b);       break;       case '2': draw(d, e);    break;
    case '3': draw(d, b);       break;       case '4': draw(a, e);    break;
    case '5': draw(b, a, e);    break;       case '6': draw(a, d);    break;
    case '7': draw(d, a, b);    break;       case '8': draw(a, d, e); break;
    case '9': draw(b, a, d, e); break;
  }
  // 1s
  switch (num[3]) {
    case '1': draw(b, c);       break;       case '2': draw(e, f);    break;
    case '3': draw(b, f);       break;       case '4': draw(e, c);    break;
    case '5': draw(b, c, e);    break;       case '6': draw(c, f);    break;
    case '7': draw(b, c, f);    break;       case '8': draw(e, f, c); break;
    case '9': draw(b, c, f, e); break;
  }
}
