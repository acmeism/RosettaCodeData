const SIZE = 400, HS = SIZE >> 1, WAIT = .005, SEEDS = 3000,
      TPI = Math.PI * 2, C = (Math.sqrt(10) + 1) / 2;
class Sunflower {
    constructor() {
        this.wait = WAIT;
        this.colorIndex = 0;
        this.dimension = 0;
        this.lastTime = 0;
        this.accumulator = 0;
        this.deltaTime = 1 / 60;
        this.colors = ["#ff0000", "#ff8000", "#ffff00", "#80ff00", "#00ff00", "#00ff80",
                       "#00ffff", "#0080ff", "#0000ff", "#8000ff", "#ff00ff", "#ff0080"];
        this.canvas = document.createElement('canvas');
        this.canvas.width = SIZE;
        this.canvas.height = SIZE;
        const d = document.getElementById("wnd");
        d.appendChild(this.canvas);
        this.ctx = this.canvas.getContext('2d');
    }
    draw(clr, d) {
        let r = Math.pow(d, C) / SEEDS;
        let angle = TPI * C * d;
        let x = HS + r * Math.sin(angle),
            y = HS + r * Math.cos(angle);
        this.ctx.strokeStyle = clr;
        this.ctx.beginPath();
        this.ctx.arc(x, y, d / (SEEDS / 50), 0, TPI);
        this.ctx.closePath();
        this.ctx.stroke();
    }
    update(dt) {
        if((this.wait -= dt) < 0) {
            this.draw(this.colors[this.colorIndex], this.dimension);
            this.wait = WAIT;
            if((this.dimension++) > 600) {
                this.dimension = 0;
                this.colorIndex = (this.colorIndex + 1) % this.colors.length;
            }
        }
    }
    start() {
        this.loop = (time) => {
            this.accumulator += (time - this.lastTime) / 1000;
            while(this.accumulator > this.deltaTime) {
                this.accumulator -= this.deltaTime;
                this.update(Math.min(this.deltaTime));
            }
            this.lastTime = time;
            requestAnimationFrame(this.loop);
        }
        this.loop(0);
    }
}
function start() {
    const sunflower = new Sunflower();
    sunflower.start();
}
