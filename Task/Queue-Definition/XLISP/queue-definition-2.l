[1] (define my-queue (queue 'new))

MY-QUEUE
[2] (my-queue 'push 1)

(1)
[3] (my-queue 'push 2)

(1 2)
[4] (my-queue 'emptyp)

()
[5] (my-queue 'pop)

1
[6] (my-queue 'pop)

2
[7] (my-queue 'emptyp)

#T
[8] (my-queue 'pop)

()
