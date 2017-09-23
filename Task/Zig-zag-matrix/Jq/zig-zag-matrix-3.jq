#!/usr/bin/env jq -Mnrc -f
#
# solve zigzag matrix by constructing list of 2n+1 column "runs"
# and then shifting them into final form.
#
# e.g. for n=3 initial runs are [[0],[1,2],[3,4,5],[6,7],[8]]
# runs below are shown as columns:
#
#   initial column runs    0  1  3  6  8
#                             2  4  7
#                                5
#
#   reverse cols 0,2,4     0  1  5  6  8
#                             2  4  7
#                                3
#
#   shift cols 3,4 down    0  1  5
#                             2  4  6
#                                3  7  8
#
#   shift rows left        0  1  5
#   to get final zigzag    2  4  6
#                          3  7  8

    def N:  $n ;                                # size of matrix
    def NR: 2*N - 1;                            # number of runs
    def abs: if .<0 then -. else . end ;        # absolute value
    def runlen: N-(N-.|abs) ;                   # length of run
    def makeruns: [
        foreach range(1;NR+1) as $r (           # for each run
          {c:0}                                 # state counter
        ; .l = ($r|runlen)                      # length of this run
        | .r = [range(.c;.c+.l)]                # values in this run
        | .c += .l                              # increment counter
        ; .r                                    # produce run
        ) ] ;                                   # collect into array
    def even: .%2==0 ;                          # is input even?
    def reverseruns:                            # reverse alternate runs
      .[keys|map(select(even))[]] |= reverse ;
    def zeros: [range(.|N-length)|0] ;          # array of padding zeros
    def shiftdown:
      def pad($r):                              # pad run with zeros
        if $r < N                               # determine where zeros go
        then . = . + zeros                      # at back for left runs
        else . = zeros + .                      # at front for right runs
        end ;
      reduce keys[] as $r (.;.[$r] |= pad($r)); # shift rows down with pad
    def shiftleft: [
        range(N) as $r
      | [   range($r;$r+N) as $c
          | .[$c][$r]
        ]
      ] ;
    def width: [.[][]]|max|tostring|1+length;   # width of largest value
    def justify($w): (($w-length)*" ") + . ;    # leading spaces
    def format:
        width as $w                             # compute width
      | map(map(tostring | justify($w)))[]      # justify values
      | join(" ")
    ;
      makeruns                                  # create column runs
    | reverseruns                               # reverse alternate runs
    | shiftdown                                 # shift right runs down
    | shiftleft                                 # shift rows left
    | format                                    # format final result
