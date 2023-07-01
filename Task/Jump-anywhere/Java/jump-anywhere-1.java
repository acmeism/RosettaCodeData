loop1: while (x != 0) {
    loop2: for (int i = 0; i < 10; i++) {
        loop3: do {
            //some calculations...
            if (/*some condition*/) {
                //this continue will skip the rest of the while loop code and start it over at the next iteration
                continue loop1;
            }
            //more calculations skipped by the continue if it is executed
            if (/*another condition*/) {
                //this break will end the for loop and jump to its closing brace
                break loop2;
            }
        } while (y < 10);
        //loop2 calculations skipped if the break is executed
    }
    //loop1 calculations executed after loop2 is done or if the break is executed, skipped if the continue is executed
}
