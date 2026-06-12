#!perl
use strict;
use warnings;
use MIME::Base64;
open(my($fh), "<", "favicon.ico") or die;
local $/;
print encode_base64(<$fh>);
