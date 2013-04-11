sub tod2rad($_) { [+](.comb(/\d+/) Z* 3600,60,1) * pi / 43200 }

sub rad2tod ($r) {
    my $x = $r * 43200 / pi;
    (($x xx 3 Z/ 3600,60,1) Z% 24,60,60).fmt('%02d',':');
}

sub phase ($c) { $c.polar[1] }

sub mean-time (@t) { rad2tod phase [+] map { cis tod2rad $_ }, @t }

say mean-time($_).fmt("%s is the mean time of "), $_ for
    ["23:00:17", "23:40:20", "00:12:45", "00:17:19"];
