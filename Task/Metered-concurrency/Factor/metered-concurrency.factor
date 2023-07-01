USING: calendar calendar.format concurrency.combinators
concurrency.semaphores formatting kernel sequences threads ;

10 <iota> 2 <semaphore>
[
    [
        dup now timestamp>hms
        "task %d acquired semaphore at %s\n" printf
        2 seconds sleep
    ] with-semaphore
    "task %d released\n" printf
] curry parallel-each
