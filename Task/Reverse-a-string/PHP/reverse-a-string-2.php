// Will split every Unicode character to array, reverse array and will convert it to string.
join('', array_reverse(preg_split('""u', $string, -1, PREG_SPLIT_NO_EMPTY)));
