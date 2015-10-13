sub pascal { [1], -> $prev { [0, |$prev Z+ |$prev, 0] } ... * }

.say for pascal[^10];
