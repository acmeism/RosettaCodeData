uses java.util.Arrays

var doors = new boolean[100]
Arrays.fill( doors, false )

for( pass in 1..100 ) {
    var counter = pass-1
    while( counter < 100 ) {
        doors[counter] = !doors[counter]
        counter += pass
  }
}

for( door in doors index i ) {
    print( "door ${i+1} is ${door ? 'open' : 'closed'}" )
}
