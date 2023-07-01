<?php
$h  =                             0;
$s  =   file_get_contents(__FILE__);
$l  =                    strlen($s);
foreach ( count_chars($s, 1) as $c )
                               $h -=
                       ( $c / $l ) *
                  log( $c / $l, 2 );
echo                             $h;
