multi fusc( 0 ) { 0 }
multi fusc( 1 ) { 1 }
multi fusc( $n where $n %% 2 ) { fusc $n div 2 }
multi fusc( $n ) { [+] map *.&fusc, ( $n - 1 ) div 2, ( $n + 1 ) div 2 }
put map *.&fusc, 0..60;
