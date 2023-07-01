function selection_sort(&$arr) {
    $n = count($arr);
    for($i = 0; $i < count($arr); $i++) {
        $min = $i;
        for($j = $i + 1; $j < $n; $j++){
            if($arr[$j] < $arr[$min]){
                $min = $j;
            }
        }
        list($arr[$i],$arr[$min]) = array($arr[$min],$arr[$i]);
    }
}
