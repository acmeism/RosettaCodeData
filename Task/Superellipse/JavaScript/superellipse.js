var n = 2.5, a = 200, b = 200, ctx;

function point( x, y ) {
    ctx.fillRect( x, y, 1, 1);
}

function start() {
    var can = document.createElement('canvas');
    can.width  = can.height = 600;
    ctx = can.getContext( "2d" );
    ctx.rect( 0, 0, can.width, can.height );
    ctx.fillStyle = "#000000"; ctx.fill();
    document.body.appendChild( can );

    ctx.fillStyle = "#ffffff";
    for( var t = 0; t < 1000; t += .1 ) {
       x = Math.pow( Math.abs( Math.cos( t ) ), 2 / n ) * a * Math.sign( Math.cos( t ) );
       y = Math.pow( Math.abs( Math.sin( t ) ), 2 / n ) * b * Math.sign( Math.sin( t ) );

       point( x + ( can.width >> 1 ), y + ( can.height >> 1 ) );
    }
}
