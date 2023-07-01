sub polybius ($text) {
    my $n = $text.chars.sqrt.narrow;
    $text.comb.kv.map: { $^v => ($^k % $n, $k div $n).join: ' ' }
}

sub encrypt ($message, %poly) {
    %poly.invert.hash{(flat reverse [Z] %poly{$message.comb}».words).batch(2)».reverse».join: ' '}.join
}

sub decrypt ($message, %poly) {
   %poly.invert.hash{reverse [Z] (reverse flat %poly{$message.comb}».words».reverse).batch($message.chars)}.join
}


for 'ABCDEFGHIKLMNOPQRSTUVWXYZ', 'ATTACKATDAWN',
    'BGWKZQPNDSIOAXEFCLUMTHYVR', 'FLEEATONCE',
    (flat '_', '.', 'A'..'Z', 'a'..'z', 0..9).pick(*).join, 'The invasion will start on the first of January 2023.'.subst(/' '/, '_', :g)
 -> $polybius, $message {
    my %polybius = polybius $polybius;
    say "\nUsing polybius:\n\t" ~ $polybius.comb.batch($polybius.chars.sqrt.narrow).join: "\n\t";
    say "\n  Message : $message";
    say "Encrypted : " ~ my $encrypted = encrypt $message, %polybius;
    say "Decrypted : " ~ decrypt $encrypted, %polybius;
}
