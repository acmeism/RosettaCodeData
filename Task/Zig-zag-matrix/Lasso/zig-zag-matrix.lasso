var(
     'square'  = array
    ,'size'    = integer( 5 )// for a 5 X 5 square
    ,'row'     = array
    ,'x'       = integer( 1 )
    ,'y'       = integer( 1 )
    ,'counter' = integer( 1 )
);

// create place-holder matrix
loop( $size );
   $row = array;

   loop( $size );
      $row->insert( 0 );

    /loop;

   $square->insert( $row );

/loop;

while( $counter < $size * $size );
   // check downward diagonal
   if(
         $x > 1
         &&
         $y < $square->size
         &&
         $square->get( $y + 1 )->get( $x - 1 ) == 0
      );

         $x -= 1;
         $y += 1;

   // check upward diagonal
   else(
         $x < $square->size
         &&
         $y > 1
         &&
         $square->get( $y - 1 )->get( $x + 1 ) == 0
      );

         $x += 1;
         $y -= 1;

   // check right
   else(
         (
            $y == 1
            ||
            $y == $square->size
         )
         &&
         $x < $square->size
         &&
         $square->get( $y )->get( $x + 1 ) == 0
      );

      $x += 1;

   // down
   else;
      $y += 1;

   /if;

   $square->get( $y )->get( $x ) = loop_count;

   $counter += 1;

/while;

$square;
