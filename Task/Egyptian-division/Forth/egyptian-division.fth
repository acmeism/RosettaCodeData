variable tab-end

: build ( m n -- )
    pad tab-end !
    swap >r  1 swap  \ dividend on ret stack
    begin dup r@ <= while
        2dup tab-end @ 2!
        [ 2 cells ] literal tab-end +!
        swap dup +
        swap dup +
    repeat 2drop rdrop ;

: e/mod ( m n -- q r )
    over >r build
    0 r>  \ initial quotient = 0, remainder = dividend
    pad tab-end @ [ 2 cells ] literal - do
        dup i @ >= if
            i @ -  swap i cell+ @ +  swap
        then
    [ -2 cells ] literal +loop ;

: .egypt ( m n -- )
    cr 2dup swap . ." divided by " . ." is " e/mod swap . ." remainder " . ;
