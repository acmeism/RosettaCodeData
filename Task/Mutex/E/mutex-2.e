Creating the mutex:

? def mutex := makeMutex()
# value: <mutex>

Creating the shared resource:

? var value := 0
# value: 0

Manipulating the shared resource non-atomically so as to show a problem:

? for _ in 0..1 {
>     when (def v := (&value) <- get()) -> {
>         (&value) <- put(v + 1)
>     }
> }

? value
# value: 1

The value has been incremented twice, but non-atomically, and so is 1 rather
than the intended 2.

? value := 0
# value: 0

This time, we use the mutex to protect the action.

? for _ in 0..1 {
>     mutex(fn {
>         when (def v := (&value) <- get()) -> {
>             (&value) <- put(v + 1)
>         }
>     })
> }

? value
# value: 2
