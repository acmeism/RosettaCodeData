#!/usr/bin/escript
% Play Bulls and Cows
main(_) -> random:seed(now()), bulls_and_cows:play().
