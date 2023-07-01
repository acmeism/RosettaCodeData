<?php
for ( $i = 1; $i <= 100; ++$i )
{
     $str = "";

     if (!($i % 3 ) )
          $str .= "Fizz";

     if (!($i % 5 ) )
          $str .= "Buzz";

     if ( empty( $str ) )
          $str = $i;

     echo $str . "\n";
}
?>
