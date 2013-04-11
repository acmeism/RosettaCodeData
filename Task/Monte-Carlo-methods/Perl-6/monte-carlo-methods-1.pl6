sub approximate_pi (Int $sample_size) {
    my Int $in = 0;
    (rand - 1/2)**2 + (rand - 1/2)**2 < 1/4 and ++$in
        for ^$sample_size;
    return 4 * $in / $sample_size;
}

say 'n =    100: ', approximate_pi    100;
say 'n =  1,000: ', approximate_pi  1_000;
say 'n = 10,000: ', approximate_pi 10_000;
