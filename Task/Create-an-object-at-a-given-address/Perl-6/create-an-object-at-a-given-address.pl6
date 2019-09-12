use v6;
use NativeCall;
use NativeCall::Types;

# bind to basic libc memory management
sub malloc(size_t) returns Pointer[uint8] is native {*};
sub memset(Pointer, uint32, size_t) is native {*};
sub free(Pointer[uint8]) is native {*};

my Pointer[uint8] $base-p = malloc(100);
memset($base-p, 0, 100);

# define object as a C struct that contains a short and an int
class SampleObject is repr('CStruct') {
    has uint16 $.foo is rw;
    has uint8  $.bar is rw;
}

# for arguments sake our object is at byte offset 64 in the
# allocated memory

my $offset-p =  $base-p.clone.add(64);
my $object-p := nativecast(Pointer[SampleObject], $offset-p);
note "creating object at address {+$object-p}";

my $struct := $object-p.deref;

$struct.foo = 41;
$struct.bar = 99;

# check we can update
$struct.foo++; # 42

# Check that we're actually updating the memory
use Test;

# look at the bytes directly to verify we've written to memory. Don't be too exact, as
# the positions may vary on different platforms depending on endianess and field alignment.

my $rec-size = nativesizeof(SampleObject);
my uint8 @bytes-written = (0 ..^ $rec-size).map(-> $i {$base-p[64 + $i]}).grep: * > 0;

# first field 'foo' (amount is small enough to fit in one byte)
is @bytes-written[0], 42, 'object first field';

# second field 'bar'
is @bytes-written[1], 99, 'object second field';

# verify that changing the origin changes the object values
memset($base-p, 1, 100); # set every byte to 1

is $struct.foo, 256 + 1, 'short updated at origin';
is $struct.bar, 1, 'byte updated at origin';

# tidy up
free($base-p);
done-testing;
