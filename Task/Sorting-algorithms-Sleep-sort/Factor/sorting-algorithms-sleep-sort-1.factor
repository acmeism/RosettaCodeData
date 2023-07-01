USING: threads calendar concurrency.combinators ;

: sleep-sort ( seq -- ) [ dup seconds sleep . ] parallel-each ;
