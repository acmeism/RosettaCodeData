#!usr/bin/perl
use 5.020;
use strict;
use warnings;

#Choose who goes first
binaryRand() == 0 ? flipCoin(userFirst()) : flipCoin(compFirst());

#Return a randomly generated 1 or 0
sub binaryRand
{
    return int(rand(2));
}
#Converts 1's and 0's to H's and T's, respectively.
sub convert
{
    my $randNum = binaryRand();
    if($randNum == 0)
    {
        return "T"
    }
    else
    {
        return "H";
    }
}

#Prompts for and returns a user's sequence of 3
sub uSeq
{
    print("Please enter a sequence of 3 of \"H\" and \"T\". EG: HHT\n>");
    my $uString = <STDIN>;

    while(1)
    {
        #Make it uppercase and validate input
        chomp($uString);
        $uString = uc $uString;
        #Check length and content (H's and T's only!)
        if(length $uString == 3 && (substr($uString, 0, 1) =~ /[HT]/ &&
                                    substr($uString, 1, 1) =~ /[HT]/ &&
                                    substr($uString, 2, 1) =~ /[HT]/))
        {
            last;
        }
        else
        {
            print("Error, try again. \n");
            print("Please enter a sequence of 3 of \"H\" and \"T\". EG: HHT\n");
            $uString = <STDIN>;
        }
    }
    return $uString;
}

#Returns an array with two elements: [0] user's seq, [1] random computer seq.
sub compFirst
{
    my $cSeq;
    #Randomly draw a sequence of 3
    for(my $i = 0; $i < 3; $i++)
    {
        $cSeq = $cSeq . convert();
    }

    print("The computer guesses first:\ncomp- $cSeq\n");
    my $uSeq = uSeq();
    print("user- $uSeq\n");
    my @seqArr = ($uSeq, $cSeq);
    return @seqArr;
}

#Returns an array with two elements: [0] user's seq, [1] optimal computer seq.
sub userFirst
{
    print("The user quesses first:\n");
    my $uSeq = uSeq();
    my $cSeq;
    #Generate the optimal sequence based on $uSeq
    my $middle = substr($uSeq, 1, 1);
    $middle eq "H" ? $cSeq = "T" : $cSeq = "H";
    $cSeq = $cSeq . substr($uSeq, 0, 2);

    print("user- $uSeq\ncomp- $cSeq\n");
    my @seqArr = ($uSeq, $cSeq);
    return @seqArr;
}

#Flips a coin, checking both sequences against the contents of the given array
sub flipCoin
{
    my ($uSeq, $cSeq) = @_;
    my $coin;
    while(1)
    {
        $coin = $coin . convert();
        if($coin =~ m/$uSeq/)
        {
            print("The sequence of tosses was: $coin\n");
            say("The player wins! ");
            last;
        }
        elsif($coin =~ m/$cSeq/)
        {
            print("The sequence of tosses was: $coin\n");
            say("The computer wins! ");
            last;
        }
    }
}
