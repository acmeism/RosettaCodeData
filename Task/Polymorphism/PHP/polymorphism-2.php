class Circle extends Point
{
  private $_radius;

  public function __construct()
  {
    switch( func_num_args() )
    {
      case 1:
        $circle = func_get_arg( 0 );
        $this->setFromCircle( $circle );
        break;
      case 2:
        $point = func_get_arg( 0 );
        $radius = func_get_arg( 1 );
        $this->setFromPoint( $point );
        $this->setRadius( $radius );
        break;
      case 3:
        $x = func_get_arg( 0 );
        $y = func_get_arg( 1 );
        $radius = func_get_arg( 2 );
        $this->setX( $x );
        $this->setY( $y );
        $this->setRadius( $radius );
        break;
      default:
        throw new InvalidArgumentException( 'expecting one (Circle) argument or two (Point and numeric radius) or three (numeric x, y and radius) arguments' );
    }
  }

  public function setFromCircle( Circle $circle )
  {
    $this->setX( $circle->getX() );
    $this->setY( $circle->getY() );
    $this->setRadius( $circle->getRadius() );
  }

  public function getPoint()
  {
    return new Point( $this->getX(), $this->getY() );
  }

  public function getRadius()
  {
    return $this->_radius;
  }

  public function setRadius( $radius )
  {
    if( !is_numeric( $radius ) )
    {
      throw new InvalidArgumentException( 'expecting numeric value' );
    }

    $this->_radius = (float) $radius;
  }

  public function __toString()
  {
    return 'Circle [' . $this->getPoint() . ',radius:' . $this->_radius . ']';
  }
}
