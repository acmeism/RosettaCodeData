int main()
{
    // enumerate() normally returns a linearly enumerated array, but
    // allows for the forth argument to specify a function that will
    // be called and return the value that should be in each cell. We
    // create an anonymous function (lambda) that just returns a
    // random value.
    array a = ({});
    for(int i=0; i<20; i++)
        a += ({ enumerate( 20, 1, 1, lambda(){return random(20)+1;} ) });

    // We could use for() and a[x][y] indexing, but foreach is just
    // shorter and easier to use even if the 2D-array becomes less
    // obvious.
 mynestedloops:
    foreach(a, array inner_a) {
        foreach(inner_a, int value) {
            write(value +" ");
            if(value == 20)
                break mynestedloops;
        }
    }
    write("\n");
}
