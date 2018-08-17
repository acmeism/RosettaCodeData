method sorttable-pos($column = 0, $reverse?, &ordering = &infix:<cmp>) {
    my @result = self»[$column].sort: &ordering;
    return $reverse ?? @result.reverse !! @result;
}
