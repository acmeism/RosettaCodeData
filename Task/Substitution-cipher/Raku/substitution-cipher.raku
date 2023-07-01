my $chr = (' ' .. '}').join('');
my $key = $chr.comb.pick(*).join('');

# Be very boring and use the same key every time to fit task reqs.
$key = q☃3#}^",dLs*>tPMcZR!fmC rEKhlw1v4AOgj7Q]YI+|pDB82a&XFV9yzuH<WT%N;iS.0e:`G\n['6@_{bk)=-5qx(/?$JoU☃;

sub MAIN ($action = 'encode', $file = '') {

    die 'Only options are encode or decode.' unless $action ~~ any 'encode'|'decode';

    my $text = qq:to/END/;
        Here we have to do is there will be a input/source file in which
        we are going to Encrypt the file by replacing every upper/lower
        case alphabets of the source file with another predetermined
        upper/lower case alphabets or symbols and save it into another
        output/encrypted file and then again convert that output/encrypted
        file into original/decrypted file. This type of Encryption/Decryption
        scheme is often called a Substitution Cipher.
        END

    $text = $file.IO.slurp if $file;

    say "Key = $key\n";

    if $file {
        say &::($action)($text);
    } else {
        my $encoded;
        say "Encoded text: \n {$encoded = encode $text}";
        say "Decoded text: \n {decode $encoded}";
    }
}

sub encode ($text) { $text.trans($chr => $key) }

sub decode ($text) { $text.trans($key => $chr) }
