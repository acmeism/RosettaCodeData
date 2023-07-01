class KnightTour {
 constructor() {
  this.width = 856;
  this.height = 856;
  this.cellCount = 8;
  this.size = 0;
  this.knightPiece = "\u2658";
  this.knightPos = {
   x: 0,
   y: 0
  };
  this.ctx = null;
  this.step = this.width / this.cellCount;
  this.lastTime = 0;
  this.wait;
  this.delay;
  this.success;
  this.jumps;
  this.directions = [];
  this.visited = [];
  this.path = [];
  document.getElementById("start").addEventListener("click", () => {
   this.startHtml();
  });
  this.init();
  this.drawBoard();
 }

 drawBoard() {
  let a = false, xx, yy;
  for (let y = 0; y < this.cellCount; y++) {
   for (let x = 0; x < this.cellCount; x++) {
    if (a) {
     this.ctx.fillStyle = "#607db8";
    } else {
     this.ctx.fillStyle = "#aecaf0";
    }
    a = !a;
    xx = x * this.step;
    yy = y * this.step;
    this.ctx.fillRect(xx, yy, xx + this.step, yy + this.step);
   }
   if (!(this.cellCount & 1)) a = !a;
  }
  if (this.path.length) {
   const s = this.step >> 1;
   this.ctx.lineWidth = 3;
   this.ctx.fillStyle = "black";
   this.ctx.beginPath();
   this.ctx.moveTo(this.step * this.knightPos.x + s, this.step * this.knightPos.y + s);
   let a, b, v = this.path.length - 1;
   for (; v > -1; v--) {
    a = this.path[v].pos.x * this.step + s;
    b = this.path[v].pos.y * this.step + s;
    this.ctx.lineTo(a, b);
    this.ctx.fillRect(a - 5, b - 5, 10, 10);
   }
   this.ctx.stroke();
  }
 }

 createMoves(pos) {
  const possibles = [];
  let x = 0,
   y = 0,
   m = 0,
   l = this.directions.length;
  for (; m < l; m++) {
   x = pos.x + this.directions[m].x;
   y = pos.y + this.directions[m].y;
   if (x > -1 && x < this.cellCount && y > -1 && y < this.cellCount && !this.visited[x + y * this.cellCount]) {
    possibles.push({
     x,
     y
    })
   }
  }
  return possibles;
 }

 warnsdorff(pos) {
  const possibles = this.createMoves(pos);
  if (possibles.length < 1) return [];
  const moves = [];
  for (let p = 0, l = possibles.length; p < l; p++) {
   let ps = this.createMoves(possibles[p]);
   moves.push({
    len: ps.length,
    pos: possibles[p]
   });
  }
  moves.sort((a, b) => {
   return b.len - a.len;
  });
  return moves;
 }

 startHtml() {
  this.cellCount = parseInt(document.getElementById("cellCount").value);
  this.size = Math.floor(this.width / this.cellCount)
  this.wait = this.delay = parseInt(document.getElementById("delay").value);
  this.step = this.width / this.cellCount;
  this.ctx.font = this.size + "px Arial";
  document.getElementById("log").innerText = "";
  document.getElementById("path").innerText = "";
  this.path = [];
  this.jumps = 1;
  this.success = true;
  this.visited = [];
  const cnt = this.cellCount * this.cellCount;
  for (let a = 0; a < cnt; a++) {
   this.visited.push(false);
  }
  const kx = parseInt(document.getElementById("knightx").value),
   ky = parseInt(document.getElementById("knighty").value);
  this.knightPos = {
   x: (kx > this.cellCount || kx < 0) ? Math.floor(Math.random() * this.cellCount) : kx,
   y: (ky > this.cellCount || ky < 0) ? Math.floor(Math.random() * this.cellCount) : ky
  };
  this.mainLoop = (time = 0) => {
   const dif = time - this.lastTime;
   this.lastTime = time;
   this.wait -= dif;
   if (this.wait > 0) {
    requestAnimationFrame(this.mainLoop);
    return;
   }
   this.wait = this.delay;
   let moves;
   if (this.success) {
    moves = this.warnsdorff(this.knightPos);
   } else {
    if (this.path.length > 0) {
     const path = this.path[this.path.length - 1];
     moves = path.m;
     if (moves.length < 1) this.path.pop();
     this.knightPos = path.pos
     this.visited[this.knightPos.x + this.knightPos.y * this.cellCount] = false;
     this.jumps--;
     this.wait = this.delay;
    } else {
     document.getElementById("log").innerText = "Can't find a solution!";
     return;
    }
   }
   this.drawBoard();
   const ft = this.step - (this.step >> 3);
   this.ctx.fillStyle = "#000";
   this.ctx.fillText(this.knightPiece, this.knightPos.x * this.step, this.knightPos.y * this.step + ft);
   if (moves.length < 1) {
    if (this.jumps === this.cellCount * this.cellCount) {
     document.getElementById("log").innerText = "Tour finished!";
     let str = "";
     for (let z of this.path) {
      str += `${1 + z.pos.x + z.pos.y * this.cellCount}, `;
     }
     str += `${1 + this.knightPos.x + this.knightPos.y * this.cellCount}`;
     document.getElementById("path").innerText = str;
     return;
    } else {
     this.success = false;
    }
   } else {
    this.visited[this.knightPos.x + this.knightPos.y * this.cellCount] = true;
    const move = moves.pop();
    this.path.push({
     pos: this.knightPos,
     m: moves
    });
    this.knightPos = move.pos
    this.success = true;
    this.jumps++;
   }
   requestAnimationFrame(this.mainLoop);
  };
  this.mainLoop();
 }

 init() {
  const canvas = document.createElement("canvas");
  canvas.id = "cv";
  canvas.width = this.width;
  canvas.height = this.height;
  this.ctx = canvas.getContext("2d");
  document.getElementById("out").appendChild(canvas);
  this.directions = [{
    x: -1,
    y: -2
   }, {
    x: -2,
    y: -1
   }, {
    x: 1,
    y: -2
   }, {
    x: 2,
    y: -1
   },
   {
    x: -1,
    y: 2
   }, {
    x: -2,
    y: 1
   }, {
    x: 1,
    y: 2
   }, {
    x: 2,
    y: 1
   }
  ];
 }
}
new KnightTour();
