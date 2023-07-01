#!bin/usr/perl
use 5.020;
use strict;
use warnings;

#Get a max number from the user
say("Please enter the maximum possible multiple. ");
my $max = <STDIN>;

#Get the factors from the user
my @factors = ();
my $buffer;
say("Now enter the first factor and its associated word. Ex: 3 Fizz ");
chomp($buffer = <STDIN>);
push @factors, $buffer;
say("Now enter the second factor and its associated word. Ex: 5 Buzz ");
chomp($buffer = <STDIN>);
push @factors, $buffer;
say("Now enter the third factor and its associated word. Ex: 7 Baxx ");
chomp($buffer = <STDIN>);
push @factors, $buffer;

#Counting from 1 to max
for(my $i = 1; $i <= $max; $i++)
{
    #Create a secondary buffer as well as set the original buffer to the current index
    my $oBuffer;
    $buffer = $i;
    #Run through each element in our array
    foreach my $element (@factors)
    {
        #Look for white space
        $element =~ /\s/;
        #If the int is a factor of max, append it to oBuffer as a string to be printed
        if($i % substr($element, 0, @-) == 0)
        {
            $oBuffer = $oBuffer . substr($element, @+ + 1, length($element));
            #This is essentially setting a flag saying that at least one element is a factor
            $buffer = "";
        }
    }
    #If there are any factors for that number, print their words. If not, print the number.
    if(length($buffer) > 0)
    {
        print($buffer . "\n");
    }
    else
    {
        print($oBuffer . "\n");
    }
}
