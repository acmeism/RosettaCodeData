# Fairly straightforward implementation, actually returns a list of pairs
# which can be joined to make a string or manipulated further.

sub mfkh ($string, \K = 2) {
    my %h;
    $string.comb.kv.map: { %h{$^v}[1] //= $^k; %h{$^v}[0]++ };
    %h.sort( { -$_.value[0], $_.value[1] } ).head(K).map( { $_.key => $_.value[0] } );
}

# lets try running 150 or so words from unixdic.txt through it to see
# how many unique hash values it comes up with.

my @test-words = <
    aminobenzoic arginine asinine biennial biennium brigantine brinkmanship
    britannic chinquapin clinging corinthian declination dickinson dimension
    dinnertime dionysian diophantine dominican financial financier finessing
    fingernail fingerprint finnish giovanni hopkinsian inaction inalienable
    inanimate incaution incendiary incentive inception incident incidental
    incinerate incline inclusion incommunicable incompletion inconceivable
    inconclusive incongruity inconsiderable inconsiderate inconspicuous
    incontrovertible inconvertible incurring incursion indefinable indemnify
    indemnity indeterminacy indian indiana indicant indifferent indigene
    indigenous indigent indispensable indochina indochinese indoctrinate
    indonesia inequivalent inexplainable infantile inferential inferring
    infestation inflammation inflationary influential information infringe
    infusion ingenious ingenuity ingestion ingredient inhabitant inhalation
    inharmonious inheritance inholding inhomogeneity inkling inoffensive
    inordinate inorganic inputting inseminate insensible insincere insinuate
    insistent insomnia insomniac insouciant installation instinct instinctual
    insubordinate insubstantial insulin insurrection intangible intelligent
    intensify intensive interception interruption intestinal intestine
    intoxicant introduction introversion intrusion invariant invasion inventive
    inversion involution justinian kidnapping kingpin lineprinter liniment
    livingston mainline mcginnis minion minneapolis minnie pigmentation
    pincushion pinion quinine quintessential resignation ruination seminarian
    triennial wilkinson wilmington wilsonian wineskin winnie winnipeg
>;

say @test-words.map( { join '', mfkh($_)».kv } ).Bag;
