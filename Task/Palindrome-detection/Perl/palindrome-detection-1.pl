# Palindrome.pm
package Palindrome;

use strict;
use warnings;

use Exporter 'import';
our @EXPORT = qw(palindrome palindrome_c palindrome_r palindrome_e);

sub palindrome
{
    my $s = (@_ ? shift : $_);
    return $s eq reverse $s;
}

sub palindrome_c
{
    my $s = (@_ ? shift : $_);
    for my $i (0 .. length($s) >> 1)
    {
        return 0 unless substr($s, $i, 1) eq substr($s, -1 - $i, 1);
    }
    return 1;
}

sub palindrome_r
{
    my $s = (@_ ? shift : $_);
    if (length $s <= 1) { return 1; }
    elsif (substr($s, 0, 1) ne substr($s, -1, 1)) { return 0; }
    else { return palindrome_r(substr($s, 1, -1)); }
}

sub palindrome_e
{
    (@_ ? shift : $_) =~ /^(.?|(.)(?1)\2)$/ + 0
}
