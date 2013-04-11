function selectionsort($arr,$result=array()){
    if(count($arr) == 0){
        return $result;
    }
    $nresult = $result;
    $nresult[] = min($arr);
    unset($arr[array_search(min($arr),$arr)]);
    return selectionsort($arr,$nresult);	
}
