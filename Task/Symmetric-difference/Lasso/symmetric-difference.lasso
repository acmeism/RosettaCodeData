[
var(
    'a'  = array(
       'John'
      ,'Bob'
      ,'Mary'
      ,'Serena'
    )

   ,'b'  = array

);

$b->insert( 'Jim' ); // Alternate method of populating array
$b->insert( 'Mary' );
$b->insert( 'John' );
$b->insert( 'Bob' );

$a->sort( true ); // arrays must be sorted (true = ascending) for difference to work
$b->sort( true );

$a->difference( $b )->union( $b->difference( $a ) );

]
