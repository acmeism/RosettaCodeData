function GameOfLife () {

	this.init = function (turns,width,height) {
		this.board = new Array(height);
		for (var x = 0; x < height; x++) {
			this.board[x] = new Array(width);
			for (var y = 0; y < width; y++) {
				this.board[x][y] = Math.round(Math.random());
			}
		}
		this.turns = turns;
	}

	this.nextGen = function() {
		this.boardNext = new Array(this.board.length);
		for (var i = 0; i < this.board.length; i++) {
			this.boardNext[i] = new Array(this.board[i].length);
		}
		for (var x = 0; x < this.board.length; x++) {
			for (var y = 0; y < this.board[x].length; y++) {
				var n = 0;
				for (var dx = -1; dx <= 1; dx++) {
					for (var dy = -1; dy <= 1; dy++) {
						if ( dx == 0 && dy == 0){}
						else if (typeof this.board[x+dx] !== 'undefined'
								&& typeof this.board[x+dx][y+dy] !== 'undefined'
								&& this.board[x+dx][y+dy]) {
							n++;
						}
					}	
				}
				var c = this.board[x][y];
				switch (n) {
					case 0:
					case 1:
						c = 0;
						break;
					case 2:
						break;
					case 3:
						c = 1;
						break;
					default:
						c = 0;
				}
				this.boardNext[x][y] = c;
			}
		}
		this.board = this.boardNext.slice();
	}

	this.print = function() {
		for (var x = 0; x < this.board.length; x++) {
			var l = "";
			for (var y = 0; y < this.board[x].length; y++) {
				if (this.board[x][y])
					l += "X";
				else
					l += " ";
			}
			print(l);
		}
	}

	this.start = function() {
		for (var t = 0; t < this.turns; t++) {
			print("---\nTurn "+(t+1));
			this.print();
			this.nextGen()
		}
	}

}


var game = new GameOfLife();

print("---\n3x3 Blinker over three turns.");
game.init(3);
game.board = [
	[0,0,0],
	[1,1,1],
	[0,0,0]];
game.start();

print("---\n10x6 Glider over five turns.");
game.init(5);
game.board = [
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,1,0,0,0,0,0,0,0],
	[0,0,0,1,0,0,0,0,0,0],
	[0,1,1,1,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0]];
game.start();

print("---\nRandom 5x10");
game.init(5,5,10);
game.start();
