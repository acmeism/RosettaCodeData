var ctx, sizeW, sizeH, scl = 10, map, tmp;
function getNeighbour( i, j ) {
    var ii, jj, c = 0;
    for( var b = -1; b < 2; b++ ) {
        for( var a = -1; a < 2; a++ ) {
            ii = i + a; jj = j + b;
            if( ii < 0 || ii >= sizeW || jj < 0 || jj >= sizeH ) continue;
            if( map[ii][jj] == 1 ) c++;
        }
    }
    return ( c == 1 || c == 2 );
}
function simulate() {
    drawWorld();
    for( var j = 0; j < sizeH; j++ ) {
        for( var i = 0; i < sizeW; i++ ) {
            switch( map[i][j] ) {
                case 0: tmp[i][j] = 0; break;
                case 1: tmp[i][j] = 2; break;
                case 2: tmp[i][j] = 3; break;
                case 3:
                    if( getNeighbour( i, j ) ) tmp[i][j] = 1;
                    else tmp[i][j] = 3;
                break;
            }
        }
    }
    [tmp, map] = [map, tmp];
    setTimeout( simulate, 200 );
}
function drawWorld() {
    ctx.fillStyle = "#000"; ctx.fillRect( 0, 0, sizeW * scl, sizeH * scl );
    for( var j = 0; j < sizeH; j++ ) {
        for( var i = 0; i < sizeW; i++ ) {
            switch( map[i][j] ) {
                case 0: continue;
                case 1: ctx.fillStyle = "#03f"; break;
                case 2: ctx.fillStyle = "#f30"; break;
                case 3: ctx.fillStyle = "#ff3"; break;
            }
            ctx.fillRect( i, j, 1, 1 );
        }
    }
}
function openFile( event ) {
    var input = event.target;
    var reader = new FileReader();
    reader.onload = function() {
        createWorld( reader.result );
    };
    reader.readAsText(input.files[0]);
}
function createWorld( txt ) {
    var l = txt.split( "\n" );
    sizeW = parseInt( l[0] );
    sizeH = parseInt( l[1] );
    map = new Array( sizeW );
    tmp = new Array( sizeW );
    for( var i = 0; i < sizeW; i++ ) {
        map[i] = new Array( sizeH );
        tmp[i] = new Array( sizeH );
        for( var j = 0; j < sizeH; j++ ) {
            map[i][j] = tmp[i][j] = 0;
        }
    }
    var t;
    for( var j = 0; j < sizeH; j++ ) {
        for( var i = 0; i < sizeW; i++ ) {
            switch( l[j + 2][i] ) {
                case " ": t = 0; break;
                case "H": t = 1; break;
                case "t": t = 2; break;
                case ".": t = 3; break;
            }
            map[i][j] = t;
        }
    }
    init();
}
function init() {
    var canvas = document.createElement( "canvas" );
    canvas.width = sizeW * scl;
    canvas.height = sizeH * scl;
    ctx = canvas.getContext( "2d" );
    ctx.scale( scl, scl );
    document.body.appendChild( canvas );
    simulate();
}
