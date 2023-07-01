class Card
{
    // if unable to save as UTF-8, use other, non-UTF-8, symbols here
    protected static $suits = array( '♠', '♥', '♦', '♣' );

    protected static $pips = array( '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A' );

    protected $suit;

    protected $suitOrder;

    protected $pip;

    protected $pipOrder;

    protected $order;

    public function __construct( $suit, $pip )
    {
        if( !in_array( $suit, self::$suits ) )
        {
            throw new InvalidArgumentException( 'Invalid suit' );
        }
        if( !in_array( $pip, self::$pips ) )
        {
            throw new InvalidArgumentException( 'Invalid pip' );
        }

        $this->suit = $suit;
        $this->pip = $pip;
    }

    public function getSuit()
    {
        return $this->suit;
    }

    public function getPip()
    {
        return $this->pip;
    }

    public function getSuitOrder()
    {
        // lazy evaluate suit order
        if( !isset( $this->suitOrder ) )
        {
            // cache suit order
            $this->suitOrder = array_search( $this->suit, self::$suits );
        }

        return $this->suitOrder;
    }

    public function getPipOrder()
    {
        // lazy evaluate pip order
        if( !isset( $this->pipOrder ) )
        {
            // cache pip order
            $this->pipOrder = array_search( $this->pip, self::$pips );
        }

        return $this->pipOrder;
    }

    public function getOrder()
    {
        // lazy evaluate order
        if( !isset( $this->order ) )
        {
            $suitOrder = $this->getSuitOrder();
            $pipOrder = $this->getPipOrder();
            // cache order
            $this->order = $pipOrder * count( self::$suits ) + $suitOrder;
        }

        return $this->order;
    }

    public function compareSuit( Card $other )
    {
        return $this->getSuitOrder() - $other->getSuitOrder();
    }

    public function comparePip( Card $other )
    {
        return $this->getPipOrder() - $other->getPipOrder();
    }

    public function compare( Card $other )
    {
        return $this->getOrder() - $other->getOrder();
    }

    public function __toString()
    {
        return $this->suit . $this->pip;
    }

    public static function getSuits()
    {
        return self::$suits;
    }

    public static function getPips()
    {
        return self::$pips;
    }
}

class CardCollection
    implements Countable, Iterator
{
    protected $cards = array();

    protected function __construct( array $cards = array() )
    {
        foreach( $cards as $card )
        {
            $this->addCard( $card );
        }
    }

    /**
      * Countable::count() implementation
      */
    public function count()
    {
        return count( $this->cards );
    }

    /**
      * Iterator::key() implementation
      */
    public function key()
    {
        return key( $this->cards );
    }

    /**
      * Iterator::valid() implementation
      */
    public function valid()
    {
        return null !== $this->key();
    }

    /**
      * Iterator::next() implementation
      */
    public function next()
    {
        next( $this->cards );
    }

    /**
      * Iterator::current() implementation
      */
    public function current()
    {
        return current( $this->cards );
    }

    /**
      * Iterator::rewind() implementation
      */
    public function rewind()
    {
        reset( $this->cards );
    }

    public function sort( $comparer = null )
    {
        $comparer = $comparer ?: function( $a, $b ) {
            return $a->compare( $b );
        };

        if( !is_callable( $comparer ) )
        {
            throw new InvalidArgumentException( 'Invalid comparer; comparer should be callable' );
        }

        usort( $this->cards, $comparer );
        return $this;
    }

    public function toString()
    {
        return implode( ' ', $this->cards );
    }

    public function __toString()
    {
        return $this->toString();
    }

    protected function addCard( Card $card )
    {
        if( in_array( $card, $this->cards ) )
        {
            throw new DomainException( 'Card is already present in this collection' );
        }

        $this->cards[] = $card;
    }
}

class Deck
    extends CardCollection
{
    public function __construct( $shuffled = false )
    {
        foreach( Card::getSuits() as $suit )
        {
            foreach( Card::getPips() as $pip )
            {
                $this->addCard( new Card( $suit, $pip ) );
            }
        }

        if( $shuffled )
        {
            $this->shuffle();
        }
    }

    public function deal( $amount = 1, CardCollection $cardCollection = null )
    {
        if( !is_int( $amount ) || $amount < 1 )
        {
            throw new InvalidArgumentException( 'Invalid amount; amount should be an integer, larger than 0' );
        }

        if( $amount > count( $this->cards ) )
        {
            throw new RangeException( 'Invalid amount; requested amount is larger than the amount of available cards' );
        }

        $cards = array_splice( $this->cards, 0, $amount );

        $cardCollection = $cardCollection ?: new CardCollection;

        foreach( $cards as $card )
        {
            $cardCollection->addCard( $card );
        }

        return $cardCollection;
    }

    public function shuffle()
    {
        shuffle( $this->cards );
    }
}

class Hand
    extends CardCollection
{
    // override CardCollection __constructor
    // to allow public instantiation
    // but disallow instantiation with cards
    public function __construct() {}

    public function play( $position )
    {
        if( !isset( $this->cards[ $position ] ) )
        {
            throw new OutOfBoundsException( 'Invalid position; position is not present in this hand' );
        }

        $result = array_splice( $this->cards, $position, 1 );
        return $result[ 0 ];
    }
}
