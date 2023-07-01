#!/usr/bin/perl

my @even_numbers;

for (1..7)
{
  if ( $_ % 2 == 0)
  {
    push @even_numbers, $_;
  }
}
	
print "Police\tFire\tSanitation\n";

foreach my $police_number (@even_numbers)
{
  for my $fire_number (1..7)
  {
    for my $sanitation_number (1..7)
    {
      if ( $police_number + $fire_number + $sanitation_number == 12 &&
           $police_number != $fire_number &&
           $fire_number != $sanitation_number &&
           $sanitation_number != $police_number)
      {
        print "$police_number\t$fire_number\t$sanitation_number\n";
      }
    }
  }	
}
