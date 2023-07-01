config const gridHeight: int = 100;
config const gridWidth: int = 100;

class PBMWriter {
  var imgDomain: domain(2);
  var imgData: [imgDomain] int;

  proc PBMWriter( height: int, width: int ){
    imgDomain = { 1..#height, 1..#width };
  }

  proc this( i : int, j : int) ref : int{
    return this.imgData[ i, j ];
  }

  proc writeImage( fileName: string ){
    var file = open(fileName, iomode.cw);
    var writingChannel = file.writer();
    writingChannel.write("P1\n", imgDomain.dim(1).size, " " ,imgDomain.dim(2).size,"\n");

    for px in imgData {
      writingChannel.write( px, " " );
    }

    writingChannel.write( "\n" );
    writingChannel.flush();
    writingChannel.close();
  }

}

enum Color { white, black };

inline proc nextDirection( position: 2*int, turnLeft: bool ): 2*int {
  return ( (if turnLeft then 1 else -1 ) * position[2], (if turnLeft then -1 else 1 ) * position[1] );
}

proc <( left: 2*int, right: 2*int ){
  return left[1] < right[1] && left[2] < right[2];
}

proc <=( left: 2*int, right: 2*int ){
  return left[1] <= right[1] && left[2] <= right[2];
}

proc main{
  const gridDomain: domain(2) = {1..#gridHeight, 1..#gridWidth};
  var grid: [gridDomain] Color;

  var antPos = ( gridHeight / 2, gridWidth / 2 );
  var antDir = (1,0); // start up;

  while (0,0) < antPos && antPos <= (gridHeight, gridWidth ) {
    var currColor = grid[ antPos ];
    grid[antPos] = if currColor == Color.white then Color.black else Color.white ;

    antDir = nextDirection( antDir, currColor == Color.black );
    antPos = antPos + antDir;
  }

  var image = new PBMWriter( height = gridHeight, width = gridWidth );

  for (i, j) in gridDomain {
    image[i,j] = if grid[gridHeight-j+1,gridHeight-i+1] == Color.black then 0 else 1;
  }

  image.writeImage( "output.png" );
}
