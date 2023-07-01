/**
 * @typedef {{
 *    x: (!number),
 *    y: (!number)
 * }}
 */
let pointType;

/**
 * @param {!Array<pointType>} l
 * @param {number} eps
 */
const RDP = (l, eps) => {
  const last = l.length - 1;
  const p1 = l[0];
  const p2 = l[last];
  const x21 = p2.x - p1.x;
  const y21 = p2.y - p1.y;

  const [dMax, x] = l.slice(1, last)
      .map(p => Math.abs(y21 * p.x - x21 * p.y + p2.x * p1.y - p2.y * p1.x))
      .reduce((p, c, i) => {
        const v = Math.max(p[0], c);
        return [v, v === p[0] ? p[1] : i + 1];
      }, [-1, 0]);

  if (dMax > eps) {
    return [...RDP(l.slice(0, x + 1), eps), ...RDP(l.slice(x), eps).slice(1)];
  }
  return [l[0], l[last]]
};

const points = [
  {x: 0, y: 0},
  {x: 1, y: 0.1},
  {x: 2, y: -0.1},
  {x: 3, y: 5},
  {x: 4, y: 6},
  {x: 5, y: 7},
  {x: 6, y: 8.1},
  {x: 7, y: 9},
  {x: 8, y: 9},
  {x: 9, y: 9}];

console.log(RDP(points, 1));
