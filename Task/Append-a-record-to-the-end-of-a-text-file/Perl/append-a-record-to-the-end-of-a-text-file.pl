use strict;
use warnings;

use Fcntl qw( :flock SEEK_END );

use constant {
    RECORD_FIELDS => [qw( account password UID GID GECOS directory shell )],
    GECOS_FIELDS  => [qw( fullname office extension homephone email )],
    RECORD_SEP    => ':',
    GECOS_SEP     => ',',
    PASSWD_FILE   => 'passwd.txt',
};

# here's our three records
my $records_to_write = [
    {
        account  => 'jsmith',
        password => 'x',
        UID      => 1001,
        GID      => 1000,
        GECOS    => {
            fullname  => 'John Smith',
            office    => 'Room 1007',
            extension => '(234)555-8917',
            homephone => '(234)555-0077',
            email     => 'jsmith@rosettacode.org',
        },
        directory => '/home/jsmith',
        shell     => '/bin/bash',
    },
    {
        account  => 'jdoe',
        password => 'x',
        UID      => 1002,
        GID      => 1000,
        GECOS    => {
            fullname  => 'Jane Doe',
            office    => 'Room 1004',
            extension => '(234)555-8914',
            homephone => '(234)555-0044',
            email     => 'jdoe@rosettacode.org',
        },
        directory => '/home/jdoe',
        shell     => '/bin/bash',
    },
];
my $record_to_append = {
    account  => 'xyz',
    password => 'x',
    UID      => 1003,
    GID      => 1000,
    GECOS    => {
        fullname  => 'X Yz',
        office    => 'Room 1003',
        extension => '(234)555-8913',
        homephone => '(234)555-0033',
        email     => 'xyz@rosettacode.org',
    },
    directory => '/home/xyz',
    shell     => '/bin/bash',
};

sub record_to_string {
    my $rec    = shift;
    my $sep    = shift // RECORD_SEP;
    my $fields = shift // RECORD_FIELDS;
    my @ary;
    for my $field (@$fields) {
        my $r = $rec->{$field};
        die "Field '$field' not found" unless defined $r;    # simple sanity check
        push @ary, ( $field eq 'GECOS' ? record_to_string( $r, GECOS_SEP, GECOS_FIELDS ) : $r );
    }
    return join $sep, @ary;
}

sub write_records_to_file {
    my $records  = shift;
    my $filename = shift // PASSWD_FILE;
    open my $fh, '>>', $filename or die "Can't open $filename: $!";
    flock( $fh, LOCK_EX ) or die "Can't lock $filename: $!";
    # if someone appended while we were waiting...
    seek( $fh, 0, SEEK_END ) or die "Can't seek $filename: $!" ;
    print $fh record_to_string($_), "\n" for @$records;
    flock( $fh, LOCK_UN ) or die "Can't unlock $filename: $!";
    # note: the file is closed automatically when function returns (and refcount of $fh becomes 0)
}

# write two records to file
write_records_to_file( $records_to_write );

# append one more record to file
write_records_to_file( [$record_to_append] );

# test
{
    use Test::Simple tests => 1;

    open my $fh, '<', PASSWD_FILE or die "Can't open ", PASSWD_FILE, ": $!";
    my @lines = <$fh>;
    chomp @lines;
    ok(
        $lines[-1] eq
'xyz:x:1003:1000:X Yz,Room 1003,(234)555-8913,(234)555-0033,xyz@rosettacode.org:/home/xyz:/bin/bash',
        "Appended record: $lines[-1]"
    );
}
