USING: assocs formatting kernel math math.functions
math.statistics random sequences sorting ;

2,000,000 [ 0 1 normal-random-float ] replicate   ! make data set
dup [ mean ] [ population-std ] bi                ! calculate and show
"Mean: %f\nStdev: %f\n\n" printf                  ! mean and stddev

[ 10 * floor 10 / ] map                   ! map data to buckets
histogram >alist [ first ] sort-with      ! create histogram sorted by bucket (key)
dup values supremum                       ! find maximum count
[
    [ /f 100 * >integer ] keepd             ! how big should this histogram bar be?
    [ [ CHAR: * ] "" replicate-as ] dip     ! make the bar
    "% 5.2f: %s   %d\n" printf              ! print a line of the histogram
] curry assoc-each
