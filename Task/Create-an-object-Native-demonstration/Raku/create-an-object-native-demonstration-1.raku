class FixedHash {
        has $.hash handles *;
        method new(*@args) { self.bless: hash => Hash.new: @args }
        method AT-KEY(FixedHash:D: $key is copy) is rw {
                $!hash.EXISTS-KEY($key) ?? $!hash.AT-KEY($key) !! Failure.new(q{can't store value for unknown key});
        }
        method DELETE-KEY($key) { $!hash.{$key} = Nil }
}

# Testing
my $fh = FixedHash.new: "a" => 1, "b" => 2;
say $fh<a b>;   # 1 2
$fh<b>:delete;
say $fh<a b>;   # 1 Nil
$fh<b> = 42;
say $fh<a b>;   # 1 42
say $fh<c>;     # Nil
$fh<c> = 43;    # error
