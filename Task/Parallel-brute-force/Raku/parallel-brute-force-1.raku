use Digest::SHA256::Native;
constant @alpha2 = [X~] <a   m p y z> xx 2;
constant @alpha3 = [X~] <e l m p x z> xx 3;

my %WANTED = set <
    3a7bd3e2360a3d29eea436fcfb7e44c735d117c42d1c1835420b6b9942dd4f1b
    74e1bb62f8dabb8125a58852b63bdf6eaef667cb56ac7f7cdba6d7305c50a22f
    1115dd800feaacefdf481f1f9070374a2a81e27880f187396db67958b207cbad
>;

sub find_it ( $first_two ) {
    for $first_two «~« @alpha3 -> \password {
        my \digest_hex = sha256-hex(password);
        return "{password} => {digest_hex}" if %WANTED{digest_hex}
    }
    ()
}

.say for flat @alpha2.race(:1batch).map: { find_it($_) };
