use utf8; # so we can use literal characters like ☺ in source
use Encode qw(encode);

print length encode 'UTF-8', "Hello, world! ☺";
# 17. The last character takes 3 bytes, the others 1 byte each.

print length encode 'UTF-16', "Hello, world! ☺";
# 32. 2 bytes for the BOM, then 15 byte pairs for each character.
