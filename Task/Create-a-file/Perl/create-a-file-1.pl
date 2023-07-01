use File::Spec::Functions qw(catfile rootdir);
{ # here
    open my $fh, '>', 'output.txt';
    mkdir 'docs';
};
{ # root dir
    open my $fh, '>', catfile rootdir, 'output.txt';
    mkdir catfile rootdir, 'docs';
};
