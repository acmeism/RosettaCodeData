// Set up canvas for drawing
var canvas: HTMLCanvasElement = document.createElement('canvas')
canvas.width = 600
canvas.height = 500
document.body.appendChild(canvas)
var ctx: CanvasRenderingContext2D = canvas.getContext('2d')
ctx.fillStyle = '#000'
ctx.lineWidth = 1

// constants
const degToRad: number = Math.PI / 180.0
const totalDepth: number = 9

/** Helper function that draws a line on the canvas */
function drawLine(x1: number, y1: number, x2: number, y2: number): void {
    ctx.moveTo(x1, y1)
    ctx.lineTo(x2, y2)
}

/** Draws a branch at the given point and angle and then calls itself twice */
function drawTree(x1: number, y1: number, angle: number, depth: number): void {
    if (depth !== 0) {
        let x2: number = x1 + (Math.cos(angle * degToRad) * depth * 10.0)
        let y2: number = y1 + (Math.sin(angle * degToRad) * depth * 10.0)
        drawLine(x1, y1, x2, y2)
        drawTree(x2, y2, angle - 20, depth - 1)
        drawTree(x2, y2, angle + 20, depth - 1)
    }
}

// actual drawing of tree
ctx.beginPath()
drawTree(300, 500, -90, totalDepth)
ctx.closePath()
ctx.stroke()
