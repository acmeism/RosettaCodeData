function sattoloCycle($items) {
   for ($i = 0; $i < count($items); $i++) {
        $j = floor((mt_rand() / mt_getrandmax()) * $i);
        $tmp = $items[$i];
        $items[$i] = $items[$j];
        $items[$j] = $tmp;
    }
    return $items;
}
