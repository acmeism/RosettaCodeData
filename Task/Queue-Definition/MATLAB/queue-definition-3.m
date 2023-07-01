>> myQueue = FIFOQueue({'hello'})

myQueue =

    FIFOQueue

>> push(myQueue,'jello')
>> pop(myQueue)

ans =

hello

>> pop(myQueue)

ans =

jello

>> pop(myQueue)
??? Error using ==> FIFOQueue.FIFOQueue>FIFOQueue.pop at 61
The queue is empty
