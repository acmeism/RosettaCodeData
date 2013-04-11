sub cholesky(@A) {
    my @L = @A »*» 0;
    for ^@A -> $i {
	for 0..$i -> $j {
	    @L[$i][$j] = ($i == $j ?? &sqrt !! 1/@L[$j][$j] * * )(
		@A[$i][$j] - [+] (@L[$i] Z* @L[$j])[0..$j]
	    );
	}
    }
    return @L;
}
.say for cholesky [
    [25],
    [15, 18],
    [-5,  0, 11],
];

.say for cholesky [
    [18, 22,  54,  42],
    [22, 70,  86,  62],
    [54, 86, 174, 134],
    [42, 62, 134, 106],
];
