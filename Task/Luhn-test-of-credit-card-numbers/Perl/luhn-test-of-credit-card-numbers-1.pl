sub luhn_test
{
        my @rev = reverse split //,$_[0];
        my ($sum1,$sum2,$i) = (0,0,0);

        for(my $i=0;$i<@rev;$i+=2)
        {
                $sum1 += $rev[$i];
                last if $i == $#rev;
                $sum2 += 2*$rev[$i+1]%10 + int(2*$rev[$i+1]/10);
        }
        return ($sum1+$sum2) % 10 == 0;
}
print luhn_test('49927398716');
print luhn_test('49927398717');
print luhn_test('1234567812345678');
print luhn_test('1234567812345670');
