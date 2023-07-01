hash1 = {"foo" => "bar"}

# hash literals that don't perfectly match the intended hash type must be given an explicit type specification
# the following would fail without `of String => String|Int32`
hash2 : Hash(String, String|Int32) = {"foo" => "bar"} of String => String|Int32
