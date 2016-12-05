sub pascal {
    [1], { [0, |$_ Z+ |$_, 0] } ... *
}

.say for pascal[^10];
