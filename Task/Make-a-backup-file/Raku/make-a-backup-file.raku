# Back up the given path/filename with a default extension .bk(n)
# where n is in the range 1 - $limit (default 3).
# Prints 'File not found' to STDERR if the file does not exist.
# Will not do anything if limit is set to less than 1.
# Will not follow symlinks by default.

sub backup (Str $filepath, Int :$limit = 3, Str :$ext = 'bk', Bool :$follow-symlinks = False) {
    my $abs = $follow-symlinks ?? $filepath.IO.resolve.absolute !! $filepath.IO.absolute;
    for (1 ..^ $limit).reverse -> $bnum {
        if "{$abs}.{$ext}{$bnum}".IO.e {
            "{$abs}.{$ext}{$bnum}".IO.rename: "{$abs}.{$ext}{$bnum + 1}";
        }
    }
    if $abs.IO.e {
        if $limit > 0 {
            $abs.IO.rename: "{$abs}.{$ext}1";
            my $in  = "{$abs}.{$ext}1".IO.open :r :bin or note $! and return False;
            my $out = $abs.IO.open :w :bin or note $! and return False;
            my $buffer-size = 32768; # 32Kb
            while my $buf = $in.read($buffer-size) { $out.write($buf) };
            close $in;
            close $out;
        }
    } else {
        note "File not found: $abs" and return False;
    }
    $abs # return filepath on success
}

# back up this program
backup $*PROGRAM-NAME;

# Optionally, specify limit, back-up extension pattern and whether to follow symlinks.
# Optional parameters can be in any order, in any combination.
backup 'myfile', :follow-symlinks, :limit(2), :ext('bak');
