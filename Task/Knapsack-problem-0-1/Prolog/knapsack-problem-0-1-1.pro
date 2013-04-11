:- use_module(library(clpfd)).

knapsack :-
        L = [
             item(map,  9,      150),
             item(compass,      13,     35),
             item(water,        153,    200),
             item(sandwich, 50,         160),
             item(glucose,      15,     60),
             item(tin,  68,     45),
             item(banana,       27,     60),
             item(apple,        39,     40),
             item(cheese,       23,     30),
             item(beer,         52,     10),
             item('suntan cream',       11,     70),
             item(camera,       32,     30),
             item('t-shirt',    24,     15),
             item(trousers, 48,         10),
             item(umbrella, 73,         40),
             item('waterproof trousers',        42,     70),
             item('waterproof overclothes',     43,     75),
             item('note-case',22,       80),
             item(sunglasses,   7,      20),
             item(towel,        18,     12),
             item(socks,        4,      50),
             item(book,         30,     10 )],
        length(L, N),
        length(R, N),
        R ins 0..1,
        maplist(arg(2), L, LW),
        maplist(arg(3), L, LV),
        scalar_product(LW, R, #=<, 400),
        scalar_product(LV, R, #=, VM),
        labeling([max(VM)], R),
        scalar_product(LW, R, #=, WM),
        %% affichage des résultats
        compute_lenword(L, 0, Len),
        sformat(A1, '~~w~~t~~~w|', [Len]),
        sformat(A2, '~~t~~w~~~w|', [4]),
        sformat(A3, '~~t~~w~~~w|', [5]),
        print_results(A1,A2,A3, L, R, WM, VM).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% to show the results in a good way
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
compute_lenword([], N, N).
compute_lenword([item(Name, _, _)|T], N, NF):-
        atom_length(Name, L),
        (   L > N -> N1 = L; N1 = N),
        compute_lenword(T, N1, NF).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
print_results(A1,A2,A3, [], [], WM, WR) :-
        sformat(W1, A1, [' ']),
        sformat(W2, A2, [WM]),
        sformat(W3, A3, [WR]),
        format('~w~w~w~n', [W1,W2,W3]).


print_results(A1,A2,A3, [_H|T], [0|TR], WM, VM) :-
        print_results(A1,A2,A3, T, TR, WM, VM).

print_results(A1, A2, A3, [item(Name, W, V)|T], [1|TR], WM, VM) :-
        sformat(W1, A1, [Name]),
        sformat(W2, A2, [W]),
        sformat(W3, A3, [V]),
        format('~w~w~w~n', [W1,W2,W3]),
        print_results(A1, A2, A3, T, TR, WM, VM).
