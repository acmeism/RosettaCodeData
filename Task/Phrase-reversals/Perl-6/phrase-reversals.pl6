my $s = 'rosetta code phrase reversal';

put 'Input               : ', $s;
put 'String reversed     : ', $s.flip;
put 'Each word reversed  : ', $s.words».flip;
put 'Word-order reversed : ', $s.words.reverse;
