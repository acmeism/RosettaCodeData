my $deck = new Playing_Card_Deck;
$deck->shuffle;
my %card = $deck->deal;
print uc("$card{pip} OF $card{suit}\n");
$deck->print_cards;
