identification division.
program-id. bogo-sort-program.
data division.
working-storage section.
01  array-to-sort.
    05 item-table.
        10 item          pic 999
            occurs 10 times.
01  randomization.
    05 random-seed       pic 9(8).
    05 random-index      pic 9.
01  flags-counters-etc.
    05 array-index       pic 99.
    05 adjusted-index    pic 99.
    05 temporary-storage pic 999.
    05 shuffles          pic 9(8)
        value zero.
    05 sorted            pic 9.
01  numbers-without-leading-zeros.
    05 item-no-zeros     pic z(4).
    05 shuffles-no-zeros pic z(8).
procedure division.
control-paragraph.
    accept random-seed from time.
    move function random(random-seed) to item(1).
    perform random-item-paragraph varying array-index from 2 by 1
    until array-index is greater than 10.
    display 'BEFORE SORT:' with no advancing.
    perform show-array-paragraph varying array-index from 1 by 1
    until array-index is greater than 10.
    display ''.
    perform shuffle-paragraph through is-it-sorted-paragraph
    until sorted is equal to 1.
    display 'AFTER SORT: ' with no advancing.
    perform show-array-paragraph varying array-index from 1 by 1
    until array-index is greater than 10.
    display ''.
    move shuffles to shuffles-no-zeros.
    display shuffles-no-zeros ' SHUFFLES PERFORMED.'
    stop run.
random-item-paragraph.
    move function random to item(array-index).
show-array-paragraph.
    move item(array-index) to item-no-zeros.
    display item-no-zeros with no advancing.
shuffle-paragraph.
    perform shuffle-items-paragraph,
    varying array-index from 1 by 1
    until array-index is greater than 10.
    add 1 to shuffles.
is-it-sorted-paragraph.
    move 1 to sorted.
    perform item-in-order-paragraph varying array-index from 1 by 1,
    until sorted is equal to zero
    or array-index is equal to 10.
shuffle-items-paragraph.
    move function random to random-index.
    add 1 to random-index giving adjusted-index.
    move item(array-index) to temporary-storage.
    move item(adjusted-index) to item(array-index).
    move temporary-storage to item(adjusted-index).
item-in-order-paragraph.
    add 1 to array-index giving adjusted-index.
    if item(array-index) is greater than item(adjusted-index)
    then move zero to sorted.
