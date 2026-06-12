const SIZE = 400, WAIT = .025;
class VibRects {
    constructor() {
        this.wait = WAIT;
        this.colorIndex = 0;
        this.dimension = 5;
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
        for(let d = this.dimension; d < SIZE / 2; d += 10) {
            this.draw("#404040", d);
        }
    }
    draw(clr, d) {
        this.ctx.strokeStyle = clr;
        this.ctx.beginPath();
        this.ctx.moveTo(d, d);
        this.ctx.lineTo(SIZE - d, d);
        this.ctx.lineTo(SIZE - d, SIZE - d);
        this.ctx.lineTo(d, SIZE - d);
        this.ctx.closePath();
        this.ctx.stroke();
    }
    update(dt) {
        if((this.wait -= dt) < 0) {
            this.draw(this.colors[this.colorIndex], this.dimension);
            this.wait = WAIT;
            if((this.dimension += 10) > SIZE / 2) {
                this.dimension = 5;
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
    const vibRects = new VibRects();
    vibRects.start();
}
