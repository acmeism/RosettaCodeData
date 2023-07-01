my $deck = Playing_Card_Deck->new;
$deck->shuffle;
my %card = $deck->deal;
print uc("$card{pip} OF $card{suit}\n");
$deck->print_cards;
