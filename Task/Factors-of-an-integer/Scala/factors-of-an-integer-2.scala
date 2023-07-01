def factors(num: Int) = {
    val list = (1 to math.sqrt(num).floor.toInt).filter(num % _ == 0)
    list ++ list.reverse.dropWhile(d => d*d == num).map(num / _)
}
