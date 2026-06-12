use strict;
use warnings;

sub backup {
    my($filepath,$limit,$ext) = @_;
    my $abs = readlink $filepath // $filepath; # always resolve symlinks
    for my $bnum (reverse 1 .. $limit-1) {
        rename "$abs$ext$bnum", "$abs$ext" . ++$bnum if -e "$abs$ext$bnum";
    }

    if (-e $abs) {
        if ($limit > 0) {
            my $orig = $abs . $ext . '1';
            rename $abs, $orig;
            open(IN,  '<', $orig) or die "can't open $orig: $!";
            open(OUT, '>', $abs)  or die "can't open $abs: $!";

            my $blksize = (stat IN)[11] || 2**14;          # preferred block size?
            my $buf;
            while (my $len = sysread IN, $buf, $blksize) {
                die "System read error: $!\n" if !defined $len;
                my $offset = 0;
                while ($len) {          # Handle partial writes.
                    defined(my $written = syswrite OUT, $buf, $len, $offset)
                        or die "System write error: $!\n";
                    $len    -= $written;
                    $offset += $written;
                };
            }
            close(IN);
            close(OUT);
        }
    } else {
        warn "File not found: $abs" and return 0;
    }
    $abs
}

# back up this program
backup($0,3,'.bk');
