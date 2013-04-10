%% Task: Complex Arithmetic
%% Author: Abhay Jain

-module(complex_number).
-export([calculate/0]).

-record(complex, {real, img}).

calculate() ->
    A = #complex{real=1, img=3},
    B = #complex{real=5, img=2},

    Sum = add (A, B),
    print (Sum),

    Product = multiply (A, B),
    print (Product),

    Negation = negation (A),
    print (Negation),

    Inversion = inverse (A),
    print (Inversion),

    Conjugate = conjugate (A),
    print (Conjugate).

add (A, B) ->
    RealPart = A#complex.real + B#complex.real,
    ImgPart = A#complex.img + B#complex.img,
    #complex{real=RealPart, img=ImgPart}.

multiply (A, B) ->
    RealPart = (A#complex.real * B#complex.real) - (A#complex.img * B#complex.img),
    ImgPart = (A#complex.real * B#complex.img) + (B#complex.real * A#complex.img),
    #complex{real=RealPart, img=ImgPart}.

negation (A) ->
    #complex{real=-A#complex.real, img=-A#complex.img}.

inverse (A) ->
    C = conjugate (A),
    Mod = (A#complex.real * A#complex.real) + (A#complex.img * A#complex.img),
    RealPart = C#complex.real / Mod,
    ImgPart = C#complex.img / Mod,
    #complex{real=RealPart, img=ImgPart}.

conjugate (A) ->
    RealPart = A#complex.real,
    ImgPart = -A#complex.img,
    #complex{real=RealPart, img=ImgPart}.

print (A) ->
    if A#complex.img < 0 ->
        io:format("Ans = ~p~pi~n", [A#complex.real, A#complex.img]);
       true ->
        io:format("Ans = ~p+~pi~n", [A#complex.real, A#complex.img])
    end.
