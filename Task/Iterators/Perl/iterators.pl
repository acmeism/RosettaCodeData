# 20240923 Perl programming solution

use strict;
use warnings;

sub skip_one {
   my ($it, $n) = @_;
   for (1..$n) { next unless defined $it->() }
}

sub next_element {
   my ($it) = @_;
   return $it->();
}

sub print_first_fourth_fifth {
   my ($container) = @_;
   my $it = new_iterator($container);

   print next_element($it), " ";
   skip_one($it, 2);
   print next_element($it), " ";
   print next_element($it), "\n";
}

sub print_reversed_first_fourth_fifth {
   my ($container) = @_;
   my $it = new_reverse_iterator($container);

   print next_element($it), " ";
   skip_one($it, 2);
   print next_element($it), " ";
   print next_element($it), "\n";
}

sub new_iterator {
   my ($container) = @_;
   my $index = 0;
   sub {
      return undef if $index >= @$container;
      return $container->[$index++]
   }
}

sub new_reverse_iterator {
   my ($container) = @_;
   my $index = @$container - 1;
   sub {
      return undef if $index < 0;
      return $container->[$index--]
   }
}

sub print_elements {
   my ($container) = @_;
   my $it = new_iterator($container);
   my $element;

   while (defined($element = next_element($it))) { print "$element " }
   print "\n";
}

my @days = qw(Monday Tuesday Wednesday Thursday Friday Saturday Sunday);
my @colors = qw(red yellow pink green purple orange blue);

print "All elements:\n";
print_elements(\@days);
print_elements(\@colors);

print "\nFirst, fourth, fifth:\n";
print_first_fourth_fifth(\@days);
print_first_fourth_fifth(\@colors);

print "\nLast, fourth to last, fifth to last:\n";
print_reversed_first_fourth_fifth(\@days);
print_reversed_first_fourth_fifth(\@colors);
