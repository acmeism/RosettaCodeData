sub approximate_pi (Int $sample_size) {
    $sample_size R/ [+]
        4 xx grep 0 ..^ 1/4,
                (rand - 1/2)**2 + (rand - 1/2)**2 xx
                    $sample_size;
}
