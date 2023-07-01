unit sub MAIN ($shots = 6);

my @cyl;

sub load () {
    @cyl.=rotate(-1) while @cyl[1];
    @cyl[1] = 1;
    @cyl.=rotate(-1);
}

sub spin () { @cyl.=rotate: (^@cyl).pick }

sub fire () { @cyl.=rotate; @cyl[0] }

sub LSLSFSF {
    @cyl = 0 xx $shots;
    load, spin, load, spin;
    return 1 if fire;
    spin;
    fire
}

sub LSLSFF {
    @cyl = 0 xx $shots;
    load, spin, load, spin;
    fire() || fire
}

sub LLSFSF {
    @cyl = 0 xx $shots;
    load, load, spin;
    return 1 if fire;
    spin;
    fire
}

sub LLSFF {
    @cyl = 0 xx $shots;
    load, load, spin;
    fire() || fire
}

my %revolver;
my $trials = 100000;

for ^$trials {
    %revolver<LSLSFSF> += LSLSFSF;
    %revolver<LSLSFF>  += LSLSFF;
    %revolver<LLSFSF>  += LLSFSF;
    %revolver<LLSFF>   += LLSFF;
}

say "{.fmt('%7s')}: %{(%revolver{$_} / $trials × 100).fmt('%.2f')}"
  for <LSLSFSF LSLSFF LLSFSF LLSFF>
