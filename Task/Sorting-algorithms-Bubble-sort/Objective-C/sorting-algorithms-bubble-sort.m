- (NSArray *) bubbleSort:(NSMutableArray *)unsorted {
    BOOL done = false;

    while (!done) {
        done = true;
        for (int i = 1; i < unsorted.count; i++) {
            if ( [[unsorted objectAtIndex:i-1] integerValue] > [[unsorted objectAtIndex:i] integerValue] ) {
                [unsorted exchangeObjectAtIndex:i withObjectAtIndex:i-1];
                done = false;
            }
        }
    }

    return unsorted;
}
