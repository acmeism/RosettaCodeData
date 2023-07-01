# usage: awk  -v debug=0  -f langton.awk

# Simulates the cellular automaton "Langton's ant",
# see http://en.wikipedia.org/wiki/Langton%27s_ant

function turnRight() {
	dir++
	if( dir>4 ) { dir=1 }
}
function turnLeft() {
	dir--
	if( dir<1 ) { dir=4 }
}
function move() {
	if (dir==1) { y--; z="^" }
	if (dir==3) { y++; z="v" }

	if (dir==2) { x++; z=">" }
	if (dir==4) { x--; z="<" }
}

function ant() {
	if( debug )  AntStat() 				##

	if( grid[x,y]==0 ) { turnLeft() } else { turnRight() }
	if( grid[x,y]==0 ) { color=1    } else { color=0 }

	if( debug )  print( "# action", color, dir, z )	##

	grid[x,y] = color
	move()
}

###

function AntStat() {
	printf( "Move# %d : Ant @ x=%d y=%d dir=%d %s  color=%d\n",
		 moveNr, x,y, dir,z, grid[x,y] )
}
function dumpGrid() {
	AntStat()

	printf( "Grid:" )
	for(xx=1; xx<=limit/10; xx++) {
		printf( "....+....%s", xx )
	}
	printf "\n"

	cSum=0
	for(yy=1; yy <= limit; yy++) {
		printf( "%4d:",yy )
		for(xx=1; xx <= limit; xx++) {
			c = grid[xx,yy]
			if( c ) cSum++
	c1++
	c2+=grid[xx,yy]
			if( (xx==x)&&(yy==y) ) 	{ c=z } 	# Ant
			printf( c )
		}
		printf( "\n" )
	}
	printf( "Cells: %d  'black' cells: %d  Moves: %d\n\n", limit*limit, cSum, moveNr )
}

BEGIN {
	  print( "Langton's ant\n" )

	  limit  = 72
	  for(x=1; x <= limit; x++) {
		for(y=1; y <= limit; y++) {
			grid[x,y] = 0
		}
	  }

	  moveNr =   0
	  x      =  36
	  y      =  28
	  dir    =   1	# 1=up/north 2=right/east 3=down/south 4=left/west
	  z      = "!"

	  while( moveNr < 11200 ) {
		moveNr++
 		ant()
		if(x<0 || x>limit) break
		if(y<0 || y>limit) break

		# Snapshots:
		if (moveNr==163 || moveNr==1297 || moveNr==10095 ) dumpGrid()
		if (y<=5 ) break
	  }
	  dumpGrid()
}
END	{ print("END.") }
