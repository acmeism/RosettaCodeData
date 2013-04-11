role FIFO {
    method enqueue ( *@values ) { # Add values to queue, returns the number of values added.
        self.push: @values;
        return @values.elems;
    }
    method dequeue ( ) {         # Remove and return the first value from the queue.
                                 # Return Nil if queue is empty.
        return self.elems ?? self.shift !! Nil;
    }
    method is-empty ( ) {        # Check to see if queue is empty. Returns Boolean value.
        return self.elems == 0;
    }
}
