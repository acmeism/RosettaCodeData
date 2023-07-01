class Point
{
  protected $_x;

  protected $_y;

  public function __construct()
  {
    switch( func_num_args() )
    {
      case 1:
        $point = func_get_arg( 0 );
        $this->setFromPoint( $point );
        break;
      case 2:
        $x = func_get_arg( 0 );
        $y = func_get_arg( 1 );
        $this->setX( $x );
        $this->setY( $y );
        break;
      default:
        throw new InvalidArgumentException( 'expecting one (Point) argument or two (numeric x and y) arguments' );
    }
  }

  public function setFromPoint( Point $point )
  {
    $this->setX( $point->getX() );
    $this->setY( $point->getY() );
  }

  public function getX()
  {
    return $this->_x;
  }

  public function setX( $x )
  {
    if( !is_numeric( $x ) )
    {
      throw new InvalidArgumentException( 'expecting numeric value' );
    }

    $this->_x = (float) $x;
  }

  public function getY()
  {
    return $this->_y;
  }

  public function setY( $y )
  {
    if( !is_numeric( $y ) )
    {
      throw new InvalidArgumentException( 'expecting numeric value' );
    }

    $this->_y = (float) $y;
  }

  public function output()
  {
    echo $this->__toString();
  }

  public function __toString()
  {
    return 'Point [x:' . $this->_x . ',y:' . $this->_y . ']';
  }
}
