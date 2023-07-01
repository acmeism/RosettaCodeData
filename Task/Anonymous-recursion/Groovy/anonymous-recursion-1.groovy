def fib = {
    assert it > -1
    {i -> i < 2 ? i : {j -> owner.call(j)}(i-1) + {k -> owner.call(k)}(i-2)}(it)
}
