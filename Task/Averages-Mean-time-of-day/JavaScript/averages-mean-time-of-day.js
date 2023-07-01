var args  = process.argv.slice(2);

function time_to_seconds( hms ) {
    var parts = hms.split(':');
    var h = parseInt(parts[0]);
    var m = parseInt(parts[1]);
    var s = parseInt(parts[2]);
    if ( h < 12 ) {
        h += 24;
    }
    var seconds = parseInt(parts[0]) * 60 * 60 + parseInt(parts[1]) * 60 + parseInt(parts[2]);
    return seconds;
}
function seconds_to_time( s ) {
    var h = Math.floor( s/(60 * 60) );
    if ( h < 10 ) {
        h = '0' + h;
    }
    s = s % (60 * 60);

    var m = Math.floor( s/60 );
    if ( m < 10 ) {
        m = '0' + m;
    }
    s = s % 60
    if ( s < 10 ) {
        s = '0' + s;
    }
    return h + ':' + m + ':' + s;
}

var sum = 0, count = 0, idx;
for (idx in args) {
    var seconds = time_to_seconds( args[idx] );
    sum += seconds;
    count++;
}

var seconds = Math.floor( sum / count )
console.log( 'Mean time is ', seconds_to_time(seconds));
