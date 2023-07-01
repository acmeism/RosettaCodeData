ArrayList array = new ArrayList( new int[] { 1, 2, 3, 4, 5 } );
ArrayList evens = new ArrayList();
foreach( int i in array )
{
        if( (i%2) == 0 )
                evens.Add( i );
}
foreach( int i in evens )
       System.Console.WriteLine( i.ToString() );
