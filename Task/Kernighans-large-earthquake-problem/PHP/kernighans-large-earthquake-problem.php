<?php

// make sure filename was specified on command line
if ( ! isset( $argv[1] ) )
    die( 'Data file name required' );

// open file and check for success
if ( ! $fh = fopen( $argv[1], 'r' ) )
    die ( 'Cannot open file: ' . $argv[1] );

while ( list( $date, $loc, $mag ) = fscanf( $fh, "%s %s %f" ) ) {
    if ( $mag > 6 ) {
        printf( "% -12s % -19s %.1f\n", $date, $loc, $mag );
    }
}

fclose( $fh );
