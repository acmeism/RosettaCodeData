var ctx, map, opn = [], clsd = [], start = {x:1, y:1, f:0, g:0},
goal = {x:8, y:8, f:0, g:0}, mw = 10, mh = 10, neighbours, path;

function findNeighbour( arr, n ) {
    var a;
    for( var i = 0; i < arr.length; i++ ) {
        a = arr[i];
        if( n.x === a.x && n.y === a.y ) return i;
    }
    return -1;
}
function addNeighbours( cur ) {
    var p;
    for( var i = 0; i < neighbours.length; i++ ) {
        var n = {x: cur.x + neighbours[i].x, y: cur.y + neighbours[i].y, g: 0, h: 0, prt: {x:cur.x, y:cur.y}};
        if( map[n.x][n.y] == 1 || findNeighbour( clsd, n ) > -1 ) continue;
        n.g = cur.g + neighbours[i].c; n.h = Math.abs( goal.x - n.x ) + Math.abs( goal.y - n.y );
        p = findNeighbour( opn, n );
        if( p > -1 && opn[p].g + opn[p].h <= n.g + n.h ) continue;
        opn.push( n );
    }
    opn.sort( function( a, b ) {
        return ( a.g + a.h ) - ( b.g + b.h ); } );
}
function createPath() {
    path = [];
    var a, b;
    a = clsd.pop();
    path.push( a );
    while( clsd.length ) {
        b = clsd.pop();
        if( b.x != a.prt.x || b.y != a.prt.y ) continue;
        a = b; path.push( a );
    }
 }
function solveMap() {
    drawMap();
    if( opn.length < 1 ) {
        document.body.appendChild( document.createElement( "p" ) ).innerHTML = "Impossible!";
        return;
    }
    var cur = opn.splice( 0, 1 )[0];
    clsd.push( cur );
    if( cur.x == goal.x && cur.y == goal.y ) {
        createPath(); drawMap();
        return;
    }
    addNeighbours( cur );
    requestAnimationFrame( solveMap );
}
function drawMap() {
    ctx.fillStyle = "#ee6"; ctx.fillRect( 0, 0, 200, 200 );
    for( var j = 0; j < mh; j++ ) {
        for( var i = 0; i < mw; i++ ) {
            switch( map[i][j] ) {
                case 0: continue;
                case 1: ctx.fillStyle = "#990"; break;
                case 2: ctx.fillStyle = "#090"; break;
                case 3: ctx.fillStyle = "#900"; break;
            }
            ctx.fillRect( i, j, 1, 1 );
        }
    }
    var a;
    if( path.length ) {
        var txt = "Path: " + ( path.length - 1 ) + "<br />[";
        for( var i = path.length - 1; i > -1; i-- ) {
            a = path[i];
            ctx.fillStyle = "#999";
            ctx.fillRect( a.x, a.y, 1, 1 );
            txt += "(" + a.x + ", " + a.y + ") ";
        }
        document.body.appendChild( document.createElement( "p" ) ).innerHTML = txt + "]";
        return;
    }
    for( var i = 0; i < opn.length; i++ ) {
        a = opn[i];
        ctx.fillStyle = "#909";
        ctx.fillRect( a.x, a.y, 1, 1 );
    }
    for( var i = 0; i < clsd.length; i++ ) {
        a = clsd[i];
        ctx.fillStyle = "#009";
        ctx.fillRect( a.x, a.y, 1, 1 );
    }
}
function createMap() {
    map = new Array( mw );
    for( var i = 0; i < mw; i++ ) {
        map[i] = new Array( mh );
        for( var j = 0; j < mh; j++ ) {
            if( !i || !j || i == mw - 1 || j == mh - 1 ) map[i][j] = 1;
            else map[i][j] = 0;
        }
    }
    map[5][3] = map[6][3] = map[7][3] = map[3][4] = map[7][4] = map[3][5] =
    map[7][5] = map[3][6] = map[4][6] = map[5][6] = map[6][6] = map[7][6] = 1;
    //map[start.x][start.y] = 2; map[goal.x][goal.y] = 3;
}
function init() {
    var canvas = document.createElement( "canvas" );
    canvas.width = canvas.height = 200;
    ctx = canvas.getContext( "2d" );
    ctx.scale( 20, 20 );
    document.body.appendChild( canvas );
    neighbours = [
        {x:1, y:0, c:1}, {x:-1, y:0, c:1}, {x:0, y:1, c:1}, {x:0, y:-1, c:1},
        {x:1, y:1, c:1.4}, {x:1, y:-1, c:1.4}, {x:-1, y:1, c:1.4}, {x:-1, y:-1, c:1.4}
    ];
    path = []; createMap(); opn.push( start ); solveMap();
}
