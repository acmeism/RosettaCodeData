datatype define Color = R | B
datatype define Tree  = E | T color left val right

# balance :: Color -> Tree a -> a -> Tree a -> Tree a
proc balance {color left val right} {
    datatype match $color $left $val $right {
        case B [T R [T R a x b] y c] z d -> { T R [T B $a $x $b] $y [T B $c $z $d] }
        case B [T R a x [T R b y c]] z d -> { T R [T B $a $x $b] $y [T B $c $z $d] }
        case B a x [T R [T R b y c] z d] -> { T R [T B $a $x $b] $y [T B $c $z $d] }
        case B a x [T R b y [T R c z d]] -> { T R [T B $a $x $b] $y [T B $c $z $d] }
        case col a x b                   -> { T $col $a $x $b }
    }
}
# insert :: Ord a => a -> Tree a -> Tree a
proc insert {x s} {
    datatype match [ins $x $s] {
        case [T _ a y b]  -> { T B $a $y $b }
    }
}
# ins :: Ord a => a -> Tree a -> Tree a
proc ins {x s} {
    datatype match $s {
        case E               -> { T R E $x E }
        case [T col a y b]   -> {
            if {$x < $y} { return [balance $col [ins $x $a] $y $b] }
            if {$x > $y} { return [balance $col $a $y [ins $x $b]] }
            return $s
        }
    }
}
