? def bowlian {
>     to __conformTo(guard) {
>         if (guard == boolean) { return true }
>     }
> }
> if (bowlian) { "a" } else { "b" }
# value: "a"
