IEnumerable<int> array = new List<int>( new int[] { 1, 2, 3, 4, 5 } );
IEnumerable<int> evens = array.Where( delegate( int i ) { return (i%2)==0; } );
foreach( int i in evens )
       System.Console.WriteLine( i.ToString() );
