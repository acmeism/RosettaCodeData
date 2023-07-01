interface mazeData{
	nodes:Node[]
	x:number
	y:number
	blockSize:number
}

class Node{
	x:number
	y:number
	wallsTo:Node[]
	visited = false
	constructor(x:number,y:number){
		this.x = x
		this.y = y
	}
	getTouchingNodes(nodes:Node[],blockSize:number){
    return nodes.filter(n=>
      (this != n) &&
      (Math.hypot(this.x-n.x,this.y-n.y) == blockSize )
    )
  }
	draw(ctx:CanvasRenderingContext2D,blockSize:number){
    ctx.fillStyle ='black'
    this.wallsTo.forEach(el=>{
      ctx.save()
      ctx.translate(this.x,this.y)
      ctx.rotate(Math.atan2(this.y-el.y,this.x-el.x)+ Math.PI)
      ctx.beginPath()
      ctx.moveTo(blockSize/2,blockSize/2)
      ctx.lineTo(blockSize/2,-blockSize/2)
      ctx.stroke()
      ctx.restore()
    })
  }
}

export function maze(x:number,y:number):mazeData {
	let blockSize = 20
	x *= blockSize
	y *= blockSize
	let nodes = Array((x/blockSize)*(y/blockSize)).fill(0).map((_el,i)=>
		new Node(
			(i%(x/blockSize)*(blockSize))+(blockSize/2),
			(Math.floor(i/(x/blockSize))*(blockSize))+(blockSize/2)
		)
	)
	nodes.forEach(n=>n.wallsTo = n.getTouchingNodes(nodes,blockSize))
	let que = [nodes[0]]
	while(que.length > 0){
		let current = que.shift()
		let unvisited = current
		.getTouchingNodes(nodes,blockSize)
		.filter(el=>!el.visited)
		if(unvisited.length >0){
			que.push(current)
			let chosen = unvisited[Math.floor(Math.random()*unvisited.length)];
			current.wallsTo = current.wallsTo.filter((el)=>el != chosen)
			chosen.wallsTo = chosen.wallsTo.filter((el)=>el != current)
			chosen.visited = true
			que.unshift(chosen)
		}
	}
	return {x:x,y:y,nodes:nodes,blockSize:blockSize}
}

export function display(c:HTMLCanvasElement,mazeData:mazeData){
	let ctx = c.getContext('2d')
	c.width = mazeData.x
	c.height = mazeData.y
	ctx.fillStyle = 'white'
	ctx.strokeStyle = 'black'
	ctx.fillRect(0,0,mazeData.x,mazeData.y)
	ctx.strokeRect(0,0,mazeData.x,mazeData.y)
	mazeData.nodes.forEach(el=>el.draw(ctx,mazeData.blockSize))
}
