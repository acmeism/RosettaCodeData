-module(fizzbuzz).
-export([start/1, count/2, display/0]).

fizzbuzz(N) when N rem 15 == 0 -> fizzbuzz;
fizzbuzz(N) when N rem 5  == 0 -> buzz;
fizzbuzz(N) when N rem 3  == 0 -> fizz;
fizzbuzz(N) -> N.

count(N, Limit) when N==Limit ->
    display ! fizzbuzz(N),
    display ! finished;
count(N, Limit) when N<Limit ->
    display ! fizzbuzz(N),
    count(N+1, Limit).

display() ->
    receive
        finished -> io:format("end!\n");
        fizzbuzz -> io:format("FizzBuzz!\n"), display();
        buzz     -> io:format("Buzz!\n"), display();
        fizz     -> io:format("Fizz!\n"), display();
        N        -> io:format("~p\n", [N]), display()
    end.

start(Max) ->
    register(display, spawn(fizzbuzz, display, [])),
    count(1, Max).
