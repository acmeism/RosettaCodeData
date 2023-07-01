function transpose($m) {
    return count($m) == 0 ? $m : (count($m) == 1 ? array_chunk($m[0], 1) : array_map(null, ...$m));
}
