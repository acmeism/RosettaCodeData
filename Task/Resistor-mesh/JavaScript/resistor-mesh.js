// Vector addition, scalar multiplication & dot product:
const add = (u, v) => {let i = u.length; while(i--) u[i] += v[i]; return u;};
const sub = (u, v) => {let i = u.length; while(i--) u[i] -= v[i]; return u;};
const mul = (a, u) => {let i = u.length; while(i--) u[i] *= a; return u;};
const dot = (u, v) => {let s = 0, i = u.length; while(i--) s += u[i]*v[i]; return s;};

const W = 10, H = 10, A = 11, B = 67;

function getAdjacent(node){ // Adjacency lists for square grid
  let list = [], x = node % W, y = Math.floor(node / W);
  if (x > 0)     list.push(node - 1);
  if (y > 0)     list.push(node - W);
  if (x < W - 1) list.push(node + 1);
  if (y < H - 1) list.push(node + W);
  return list;
}

function linOp(u){ // LHS of the linear equation
  let v = new Float64Array(W * H);
  for(let i = 0; i < v.length; i++){
    if ( i === A || i === B ) {
      v[i] = u[i];
      continue;
    }
    // For each node other then A, B calculate the net current flow:
    for(let j of getAdjacent(i)){
      v[i] += (j === A || j === B) ? u[i] : u[i] - u[j];
    }
  }
  return v;
}

function getRHS(phiA = 1, phiB = 0){ // RHS of the linear equation
  let b = new Float64Array(W * H);
  // Setting boundary conditions (electric potential at A and B):
  b[A] = phiA;
  b[B] = phiB;
  for(let j of getAdjacent(A)) b[j] = phiA;
  for(let j of getAdjacent(B)) b[j] = phiB;
  return b;
}

function init(phiA = 1, phiB = 0){ // initialize unknown vector
  let u = new Float64Array(W * H);
  u[A] = phiA;
  u[B] = phiB;
  return u;
}

function solveLinearSystem(err = 1e-20){ // conjugate gradient solver

  let b = getRHS();
  let u = init();
  let r = sub(linOp(u), b);
  let p = r;
  let e = dot(r,r);

  while(true){
    let Ap    = linOp(p);
    let alpha = e / dot(p, Ap);
    u = sub(u, mul(alpha, p.slice()));
    r = sub(linOp(u), b);
    let e_new = dot(r,r);
    let beta  = e_new / e;

    if(e_new < err) return u;

    e = e_new;
    p = add(r, mul(beta, p));
  }
}

function getResistance(u){
  let curr = 0;
  for(let j of getAdjacent(A)) curr += u[A] - u[j];
  return 1 / curr;
}

let phi = solveLinearSystem();
let res = getResistance(phi);
console.log(`R = ${res} Ohm`);
