/* Tile object: */

function Tile(pos, val, puzzle){
	this.pos     = pos;
	this.val     = val;
	this.puzzle  = puzzle;
	this.merging = false;
	
	this.getCol = () => Math.round(this.pos % 4);
	this.getRow = () => Math.floor(this.pos / 4);
	
	/* draw tile on a P5.js canvas: */
	
	this.show = function(){
		let padding = this.merging ? 0 : 5;
		let size = 0.25*width;
		noStroke();
		colorMode(HSB, 255);
		fill(10*(11 - Math.log2(this.val)), 50 + 15*Math.log2(this.val), 200);
		rect(this.getCol()*size + padding, this.getRow()*size + padding, size - 2*padding, size - 2*padding);
		fill(255);
		textSize(0.1*width);
		textAlign(CENTER, CENTER);
		text(this.val, (this.getCol() + 0.5)*size, (this.getRow() + 0.5)*size);
	}
	
	/* move tile in a given direction: */
	
	this.move = function(dir){
		let col = this.getCol() + (1 - 2*(dir < 0))*Math.abs(dir)%4;
		let row = this.getRow() + (1 - 2*(dir < 0))*Math.floor(Math.abs(dir)/4);
		let target = this.puzzle.getTile(this.pos + dir);
		
		if (col < 0 || col > 3 || row < 0 || row > 3) {
			/* target position out of bounds */
			return false;
		} else if (target){
			/* tile blocked by other tile */
			if(this.merging || target.merging || target.val !== this.val)
				return false;
			
			/* merge with target tile (equal values):*/
			target.val += this.val;
			target.merging = true;
			this.puzzle.score += target.val;
			this.puzzle.removeTile(this);
			return true;
		}
	
		/* move tile: */
		this.pos += dir;
		return true;
	}
}

/* Puzzle object: */

function Puzzle(){
	this.tiles    = [];
	this.dir      = 0;
	this.score    = 0;
	this.hasMoved = false;
	this.validPositions = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
	
	this.getOpenPositions = () => this.validPositions.filter(i => this.tiles.map(x => x.pos).indexOf(i) === -1);
	this.getTile          = pos => this.tiles.filter(x => x.pos === pos)[0];
	this.removeTile       = tile => this.tiles.splice(this.tiles.indexOf(tile), 1);
	this.winCondition     = () => this.tiles.some(x => x.val === 2048);

	/* check for valid moves: */
	
	this.validMoves = function(){
		/* return true if there are empty spaces */
		if(this.tiles.length < 16)
			return true;
		
		/* otherwise check for neighboring tiles with the same value */
		let res = false;
		this.tiles.sort((x,y) => x.pos - y.pos);
		for(let i = 0; i < 16; i++)
			res = res || ( (i%4 < 3) ? this.tiles[i].val === this.tiles[i+1].val : false )
					  || ( (i  < 12) ? this.tiles[i].val === this.tiles[i+4].val : false );
		return res;
	}
	
	/* check win and lose condition: */
	
	this.checkGameState = function(){
		if(this.winCondition()){
			alert('You win!');
		} else if (!this.validMoves()){
			alert('You Lose!');
			this.restart();
		}
	}
	
	this.restart = function(){
		this.tiles    = [];
		this.dir      = 0;
		this.score    = 0;
		this.hasMoved = false;
		this.generateTile();
		this.generateTile();
	}
	
	/* draw the board on the p5.js canvas: */
	
	this.show = function(){
		background(200);
		fill(255);
		textSize(0.05*width);
		textAlign(CENTER, TOP);
		text("SCORE: " + this.score, 0.5*width, width);
		
		for(let tile of this.tiles)
			tile.show();
	}
	
	/* update the board: */
	
	this.animate = function(){
		if(this.dir === 0)
			return;
		
		/* move all tiles in a given direction */
		let moving = false;
		this.tiles.sort((x,y) => this.dir*(y.pos - x.pos));
		for(let tile of this.tiles)
			moving = moving || tile.move(this.dir);
		
		/* check if the move is finished and generate a new tile */
		if(this.hasMoved && !moving){
			this.dir = 0;
			this.generateTile();
			
			for(let tile of this.tiles)
				tile.merging = false;
		}
		this.hasMoved = moving;
	}
	
	this.generateTile = function(){
		let positions = this.getOpenPositions();
		let pos       = positions[Math.floor(Math.random()*positions.length)];
		let val       = 2 + 2*Math.floor(Math.random()*1.11);
		this.tiles.push(new Tile(pos, val, this));
	}
	this.generateTile();
	this.generateTile();
	
	/* process key inputs: */
	
	this.keyHandler = function(key){
		if      (key === UP_ARROW)    this.dir = -4
		else if (key === DOWN_ARROW)  this.dir = 4
		else if (key === RIGHT_ARROW) this.dir = 1
		else if (key === LEFT_ARROW)  this.dir = -1;
	}
}


let game;

function setup() {
	createCanvas(400, 420);	
	game = new Puzzle();
}

/* game loop: */

function draw() {
	game.checkGameState();
	game.animate();
	game.show();
}

function keyPressed(){
	game.keyHandler(keyCode);
}
