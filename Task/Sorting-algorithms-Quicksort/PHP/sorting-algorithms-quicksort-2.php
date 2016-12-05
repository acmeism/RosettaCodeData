function quickSort(array $array) {
    // base case
    if (empty($array)) {
        return $array;
    }
    $head = array_shift($array);
    $tail = $array;
    $lesser = array_filter($tail, function ($item) use ($head) {
        return $item <= $head;
    });
    $bigger = array_filter($tail, function ($item) use ($head) {
        return $item > $head;
    });
    return array_merge(quickSort($lesser), [$head], quickSort($bigger));
}
$testCase = [1, 4, 8, 2, 8, 0, 2, 8];
$result = quickSort($testCase);
echo sprintf("[%s] ==> [%s]\n", implode(', ', $testCase), implode(', ', $result));
