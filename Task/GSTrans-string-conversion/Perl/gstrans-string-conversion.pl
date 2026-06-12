# 20240911 Perl programming solution

use strict;
use warnings;

sub gst_load_char {
   my ($encoded) = @_;
   if (gst_is_end($encoded)) { die "Unexpected end." }
   my $c = substr($encoded->[0], $encoded->[1], 1);
   $encoded->[1]++;
   return $c;
}

sub gst_is_end {
   my ($lst) = @_;
   return $lst->[1] >= length($lst->[0]);
}

sub gst_translate_special {
   my ($c) = @_;
   return            0 if $c eq '@';
   return           27 if $c eq '[' || $c eq '{';
   return           28 if $c eq '\\';
   return           29 if $c eq ']' || $c eq '}';
   return           30 if $c eq '^' || $c eq '~';
   return           31 if $c eq '_' || $c eq "'";
   return ord($c)      if $c eq '"' || $c eq '|' || $c eq '<' || $c eq '?';
   return ord($c) - 64 if $c ge 'A' && $c le 'Z';
   return ord($c) - 96 if $c ge 'a' && $c le 'z';
   return undef;
}

sub gst_load_highpos_token {
   my ($encoded) = @_;
   if ( ( my $c = gst_load_char($encoded) ) eq '|') {
      my $sp = gst_load_char($encoded);
      return 128 + gst_translate_special($sp);
   } elsif ($c gt chr(31) && $c lt chr(127)) {
      return 128 + ord($c);
   }
   die "Not a printable character.";
}

sub gst_load_token {
   my ($encoded) = @_;
   if ( ( my $c = gst_load_char($encoded) ) eq '|') {
      my $sp = gst_load_char($encoded);
      return ($c eq '!') ? gst_load_highpos_token($encoded)
                         : gst_translate_special($sp);
   } elsif ($c gt chr(31) && $c lt chr(127)) {
      return ord($c);
   }
   die "Not a printable character.";
}

sub gst_parse {
   my ($text) = @_;
   my ($encoded, @decoded) = ( [$text, 0], );
   while (!gst_is_end($encoded)) { push @decoded, gst_load_token($encoded) }
   return \@decoded;
}

my $decoded = gst_parse(my $text = "|LHello|G|J|M");
print "$text => (" . join(", ", @$decoded) . ")\n";
