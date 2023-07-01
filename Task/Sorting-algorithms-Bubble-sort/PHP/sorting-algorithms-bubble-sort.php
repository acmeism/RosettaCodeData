function bubbleSort(array $array){
    foreach($array as $i => &$val){
        foreach($array as $k => &$val2){
            if($k <= $i)
                continue;
            if($val > $val2) {
                list($val, $val2) = [$val2, $val];
                break;
            }
        }
    }
    return $array;
}
