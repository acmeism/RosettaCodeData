function sum_squares(array $args) {
    return array_reduce(
        $args, create_function('$x, $y', 'return $x+$y*$y;'), 0
    );
}
