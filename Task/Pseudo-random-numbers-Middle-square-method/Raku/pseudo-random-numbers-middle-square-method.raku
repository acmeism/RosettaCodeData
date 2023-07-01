sub msq {
    state $seed = 675248;
    $seed = $seed² div 1000 mod 1000000;
}

say msq() xx 5;
