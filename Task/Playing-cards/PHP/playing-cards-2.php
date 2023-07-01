// if viewing in a browser, lets output a text/plain header with utf-8 charset
header( 'Content-Type: text/plain; charset=utf-8' );

// create a new Deck
$deck = new Deck();

// show the cards in the new deck
echo count( $deck ) . ' cards in the new deck: ' . PHP_EOL . $deck . PHP_EOL;

// sort the deck, default sort
$deck->sort();

// show the cards in the sorted deck
echo PHP_EOL . count( $deck ) . ' cards in the new deck, default sort: ' . PHP_EOL . $deck . PHP_EOL;

// sort the deck, custom sort
$deck->sort( function( $a, $b ) {
    return $a->compareSuit( $b ) ?: $a->comparePip( $b );
} );

// show the cards in the sorted deck
echo PHP_EOL . count( $deck ) . ' cards in the new deck, custom sort: ' . PHP_EOL . $deck . PHP_EOL;

// shuffle the deck
$deck->shuffle();

// show the cards in the shuffled deck
echo PHP_EOL . count( $deck ) . ' cards in the new deck, shuffled: ' . PHP_EOL . $deck . PHP_EOL . PHP_EOL;

// intialize four player hands
$players = array(
    new Hand,
    new Hand,
    new Hand,
    new Hand
);

// three deal rounds, with amounts: 2, 2, 3
foreach( array( 2, 2, 3 ) as $amount )
{
    // deal this rounds amount to player
    foreach( $players as $hand )
    {
        $deck->deal( $amount, $hand );
    }
}

foreach( $players as $p => $hand )
{
    // sort player cards, default sort
    $hand->sort();
    // show player cards
    echo 'Player ' . ( $p + 1 ) . ' got dealt the following ' . count( $hand ) . ' cards (sorted): ' . $hand . PHP_EOL;
}

// show the remaining cards in the deck
echo PHP_EOL . count( $deck ) . ' cards remaining in the deck: ' . PHP_EOL . $deck . PHP_EOL;
