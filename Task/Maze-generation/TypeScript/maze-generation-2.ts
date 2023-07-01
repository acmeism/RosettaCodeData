import { maze,display } from "./maze"
const X = 10
const Y = 10

let canvas = document.createElement('canvas')
document.body.appendChild(canvas)
let m = maze(X,Y)
display(canvas,m)
