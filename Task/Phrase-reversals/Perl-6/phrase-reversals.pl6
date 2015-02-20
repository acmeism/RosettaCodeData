my $s = 'rosetta code phrase reversal';

say 'Input               : ', $s;
say 'String reversed     : ', $s.flip;
say 'Each word reversed  : ', $s.words».flip;
say 'Word-order reversed : ', $s.words.reverse;
