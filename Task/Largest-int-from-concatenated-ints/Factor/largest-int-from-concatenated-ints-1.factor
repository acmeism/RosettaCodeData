USING: assocs io kernel math qw sequences sorting ;
IN: rosetta-code.largest-int

: pad ( target seq -- padded )
    2dup length / swap <repetition> concat swap head ;

: largest-int ( seq -- )
    dup dup [ length ] map supremum    ! find longest length so we know how much to pad
    [ swap pad ] curry map             ! pad the integers
    <enum> sort-values                 ! sort the padded integers
    keys                               ! find the original indices of the sorted integers
    swap nths                          ! order non-padded integers according to their sorted order
    reverse concat print ;

qw{ 1 34 3 98 9 76 45 4 } qw{ 54 546 548 60 } [ largest-int ] bi@
