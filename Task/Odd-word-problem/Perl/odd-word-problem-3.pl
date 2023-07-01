$|=1;

while (read STDIN, $_, 1) {
	$w = /^[a-zA-Z]$/;
	$n++ if ($w && !$l);
	$l = $w;
	if ($n & 1 || !$w) {
		close W; while(wait()!=-1){}
		print;
	} else {
		open W0, ">&", \*W;
		close W;
		pipe R,W;
		if (!fork()) {
			close W;
			<R>;
			print $_;
			close W0;
			exit;
		}
		close W0;
		close R;
	}
}
