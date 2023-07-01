sub VdC($base = 2) {
    map {
        [+] $_ && .polymod($base xx *) Z/ [\*] $base xx *
    }, ^Inf
}

.say for VdC[^10];
