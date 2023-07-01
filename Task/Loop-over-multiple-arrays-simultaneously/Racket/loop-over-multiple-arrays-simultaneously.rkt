#lang racket

(for ([x '(a b c)] ; list
      [y #(A B C)] ; vector
      [z "123"]
      [i (in-naturals 1)]) ; 1, 2, ... infinitely
  (printf "~s: ~s ~s ~s\n" i x y z))
