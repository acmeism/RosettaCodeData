var maxIterations = 450, minX = -.5, maxX = .5,
    minY = -.5, maxY = .5, wid, hei, ctx,
    jsX = 0.285, jsY = 0.01;

function remap( x, t1, t2, s1, s2 ) {
    var f = ( x - t1 ) / ( t2 - t1 ),
        g = f * ( s2 - s1 ) + s1;
    return g;
}
function getColor( c ) {
    var r, g, b, p = c / 32,
        l = ~~( p * 6 ), o = p * 6 - l,
        q = 1 - o;

    switch( l % 6 ) {
        case 0: r = 1; g = o; b = 0; break;
        case 1: r = q; g = 1; b = 0; break;
        case 2: r = 0; g = 1; b = o; break;
        case 3: r = 0; g = q; b = 1; break;
        case 4: r = o; g = 0; b = 1; break;
        case 5: r = 1; g = 0; b = q; break;
    }
    var c = "#" + ( "00" + ( ~~( r * 255 ) ).toString( 16 ) ).slice( -2 ) +
                  ( "00" + ( ~~( g * 255 ) ).toString( 16 ) ).slice( -2 ) +
                  ( "00" + ( ~~( b * 255 ) ).toString( 16 ) ).slice( -2 );
    return (c);
}
function drawFractal() {
    var a, as, za, b, bs, zb, cnt, clr
    for( var j = 0; j < hei; j++ ) {
        for( var i = 0; i < wid; i++ ) {
            a = remap( i, 0, wid, minX, maxX )
            b = remap( j, 0, hei, minY, maxY )
            cnt = 0;
            while( ++cnt < maxIterations ) {
                za = a * a; zb = b * b;
                if( za + zb > 4 ) break;
                as = za - zb; bs = 2 * a * b;
                a = as + jsX; b = bs + jsY;
            }
            if( cnt < maxIterations ) {
                ctx.fillStyle = getColor( cnt );
            }
            ctx.fillRect( i, j, 1, 1 );
        }
    }
}
function init() {
    var canvas = document.createElement( "canvas" );
    wid = hei = 800;
    canvas.width = wid; canvas.height = hei;
    ctx = canvas.getContext( "2d" );
    ctx.fillStyle = "black"; ctx.fillRect( 0, 0, wid, hei );
    document.body.appendChild( canvas );
    drawFractal();
}
