class FreeCell_Deal {

    protected $deck = array(
        'AC', 'AD', 'AH', 'AS', '2C', '2D', '2H', '2S', '3C', '3D', '3H', '3S',
        '4C', '4D', '4H', '4S', '5C', '5D', '5H', '5S', '6C', '6D', '6H', '6S',
        '7C', '7D', '7H', '7S', '8C', '8D', '8H', '8S', '9C', '9D', '9H', '9S',
        'TC', 'TD', 'TH', 'TS', 'JC', 'JD', 'JH', 'JS', 'QC', 'QD', 'QH', 'QS',
        'KC', 'KD', 'KH', 'KS'
    );

    protected $game;        // Freecell Game Number
    protected $state;       // Current state of the LCG

    public $deal = array(); // Generated card sequence to deal

    function __construct( $game ) {

        $this->game = max( min( $game, 32000 ), 1 );

        // seed RNG with game number
        $this->state = $this->game;

        while ( ! empty( $this->deck ) ) {

            // choose random card
            $i = $this->lcg_rnd() % count( $this->deck );

            // move random card to game deal pile
            $this->deal[] = $this->deck[ $i ];

            // move last card to random card spot
            $this->deck[ $i ] = end( $this->deck );

            // remove last card from deck
            array_pop( $this->deck );

        }

    }

    protected function lcg_rnd() {
        return ( $this->state = ( $this->state * 214013 + 2531011 ) % 2147483648 ) >> 16;
    }

    function print( $cols = 8 ) {
        echo str_pad( " Game " . $this->game . " ", $cols * 3 - 1, '=', STR_PAD_BOTH ), PHP_EOL;
        foreach ( array_chunk( $this->deal, $cols ) as $row ) {
            echo implode( " ", $row ), PHP_EOL;
        }
        echo PHP_EOL;
    }

}

$tests = array( 1, 617, 11982 );

foreach ( $tests as $game_num ) {
    $deal = new FreeCell_Deal( $game_num );
    $deal->print();
}
