sub dual-diagonal($n) { ([1, |(0 xx $n-1)], *.rotate(-1) … *[*-1]).map: { [$_ Z|| .reverse] } }

.say for dual-diagonal(6);
say '';
.say for dual-diagonal(7);
