use NativeCall;

class utimbuf is repr('CStruct') {
    has int $.actime;
    has int $.modtime;

    submethod BUILD(:$atime, :$mtime) {
        $!actime = $atime;
        $!modtime = $mtime.to-posix[0].round;
    }
}

sub sysutime(Str, utimbuf --> int32) is native is symbol('utime') {*}

sub MAIN (Str $file) {
    my $mtime = $file.IO.modified orelse .die;

    my $ubuff = utimbuf.new(:atime(time),:mtime($mtime));

    sysutime($file, $ubuff);
}
