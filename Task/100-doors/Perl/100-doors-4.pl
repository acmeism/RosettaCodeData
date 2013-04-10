while( ++$i <= 100 )
{
    $root = sqrt($i);
    if ( int( $root ) == $root )
    {
        print "Door $i is open\n";
    }
    else
    {
        print "Door $i is closed\n";
    }
}
