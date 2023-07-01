class Mastermind {
  constructor() {
    this.colorsCnt;
    this.rptColors;
    this.codeLen;
    this.guessCnt;
    this.guesses;
    this.code;
    this.selected;
    this.game_over;
    this.clear = (el) => {
      while (el.hasChildNodes()) {
        el.removeChild(el.firstChild);
      }
    };
    this.colors = ["🤡", "👹", "👺", "👻", "👽", "👾", "🤖", "🐵", "🐭",
      "🐸", "🎃", "🤠", "☠️", "🦄", "🦇", "🛸", "🎅", "👿", "🐲", "🦋"
    ];
  }

  newGame() {
    this.selected = null;
    this.guessCnt = parseInt(document.getElementById("gssCnt").value);
    this.colorsCnt = parseInt(document.getElementById("clrCnt").value);
    this.codeLen = parseInt(document.getElementById("codeLen").value);
    if (this.codeLen > this.colorsCnt) {
      document.getElementById("rptClr").selectedIndex = 1;
    }
    this.rptColors = document.getElementById("rptClr").value === "yes";
    this.guesses = 0;
    this.game_over = false;
    const go = document.getElementById("gameover");
    go.innerText = "";
    go.style.visibility = "hidden";
    this.clear(document.getElementById("code"));
    this.buildPalette();
    this.buildPlayField();
  }

  buildPalette() {
    const pal = document.getElementById("palette"),
      z = this.colorsCnt / 5,
      h = Math.floor(z) != z ? Math.floor(z) + 1 : z;
    this.clear(pal);
    pal.style.height = `${44 * h + 3 * h}px`;
    const clrs = [];
    for (let c = 0; c < this.colorsCnt; c++) {
      clrs.push(c);
      const b = document.createElement("div");
      b.className = "bucket";
      b.clr = c;
      b.innerText = this.colors[c];
      b.addEventListener("click", () => {
        this.palClick(b);
      });
      pal.appendChild(b);
    }
    this.code = [];
    while (this.code.length < this.codeLen) {
      const r = Math.floor(Math.random() * clrs.length);
      this.code.push(clrs[r]);
      if (!this.rptColors) {
        clrs.splice(r, 1);
      }
    }
  }

  buildPlayField() {
    const brd = document.getElementById("board");
    this.clear(brd);
    const w = 49 * this.codeLen + 7 * this.codeLen + 5;
    brd.active = 0;
    brd.style.width = `${w}px`;
    document.querySelector(".column").style.width = `${w + 20}px`;
    this.addGuessLine(brd);
  }

  addGuessLine(brd) {
    const z = document.createElement("div");
    z.style.clear = "both";
    brd.appendChild(z);
    brd.active += 10;
    for (let c = 0; c < this.codeLen; c++) {
      const d = document.createElement("div");
      d.className = "bucket";
      d.id = `brd${brd.active+ c}`;
      d.clr = -1;
      d.addEventListener("click", () => {
        this.playClick(d);
      })
      brd.appendChild(d);
    }
  }

  palClick(bucket) {
    if (this.game_over) return;
    if (null === this.selected) {
      bucket.classList.add("selected");
      this.selected = bucket;
      return;
    }
    if (this.selected !== bucket) {
      this.selected.classList.remove("selected");
      bucket.classList.add("selected");
      this.selected = bucket;
      return;
    }
    this.selected.classList.remove("selected");
    this.selected = null;
  }

  vibrate() {
    const brd = document.getElementById("board");
    let timerCnt = 0;
    const exp = setInterval(() => {
      if ((timerCnt++) > 60) {
        clearInterval(exp);
        brd.style.top = "0px";
        brd.style.left = "0px";
      }
      let x = Math.random() * 4,
        y = Math.random() * 4;
      if (Math.random() < .5) x = -x;
      if (Math.random() < .5) y = -y;
      brd.style.top = y + "px";
      brd.style.left = x + "px";
    }, 10);
  }

  playClick(bucket) {
    if (this.game_over) return;
    if (this.selected) {
      bucket.innerText = this.selected.innerText;
      bucket.clr = this.selected.clr;
    } else {
      this.vibrate();
    }
  }

  check() {
    if (this.game_over) return;
    let code = [];
    const brd = document.getElementById("board");
    for (let b = 0; b < this.codeLen; b++) {
      const h = document.getElementById(`brd${brd.active + b}`).clr;
      if (h < 0) {
        this.vibrate();
        return;
      }
      code.push(h);
    }
    this.guesses++;
    if (this.compareCode(code)) {
      this.gameOver(true);
      return;
    }
    if (this.guesses >= this.guessCnt) {
      this.gameOver(false);
      return;
    }
    this.addGuessLine(brd);
  }

  compareCode(code) {
    let black = 0,
      white = 0,
      b_match = new Array(this.codeLen).fill(false),
      w_match = new Array(this.codeLen).fill(false);
    for (let i = 0; i < this.codeLen; i++) {
      if (code[i] === this.code[i]) {
        b_match[i] = true;
        w_match[i] = true;
        black++;
      }
    }
    for (let i = 0; i < this.codeLen; i++) {
      if (b_match[i]) continue;
      for (let j = 0; j < this.codeLen; j++) {
        if (i == j || w_match[j]) continue;
        if (code[i] === this.code[j]) {
          w_match[j] = true;
          white++;
          break;
        }
      }
    }
    const brd = document.getElementById("board");
    let d;
    for (let i = 0; i < black; i++) {
      d = document.createElement("div");
      d.className = "pin";
      d.style.backgroundColor = "#a00";
      brd.appendChild(d);
    }
    for (let i = 0; i < white; i++) {
      d = document.createElement("div");
      d.className = "pin";
      d.style.backgroundColor = "#eee";
      brd.appendChild(d);
    }
    return (black == this.codeLen);
  }

  gameOver(win) {
    if (this.game_over) return;
    this.game_over = true;
    const cd = document.getElementById("code");
    for (let c = 0; c < this.codeLen; c++) {
      const d = document.createElement("div");
      d.className = "bucket";
      d.innerText = this.colors[this.code[c]];
      cd.appendChild(d);
    }
    const go = document.getElementById("gameover");
    go.style.visibility = "visible";
    go.innerText = win ? "GREAT!" : "YOU FAILED!";
    const i = setInterval(() => {
      go.style.visibility = "hidden";
      clearInterval(i);
    }, 3000);
  }
}
const mm = new Mastermind();
document.getElementById("newGame").addEventListener("click", () => {
  mm.newGame()
});
document.getElementById("giveUp").addEventListener("click", () => {
  mm.gameOver();
});
document.getElementById("check").addEventListener("click", () => {
  mm.check()
});
