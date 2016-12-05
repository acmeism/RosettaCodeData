sub tod2rad($_) { [+](.comb(/\d+/) Z* 3600,60,1) * tau / 86400 }

sub rad2tod ($r) {
    my $x = $r * 86400 / tau;
    (($x xx 3 Z/ 3600,60,1) Z% 24,60,60).fmt('%02d',':');
}

sub phase ($c) { $c.polar[1] }

sub mean-time (@t) { rad2tod phase [+] map { cis tod2rad $_ }, @t }

my @times = ["23:00:17", "23:40:20", "00:12:45", "00:17:19"];

say "{ mean-time(@times) } is the mean time of @times[]";
