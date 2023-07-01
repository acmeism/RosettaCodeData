using Nettle

testdict = Dict("abc" => "a9993e364706816aba3e25717850c26c9cd0d89d",
                "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq" =>
                    "84983e441c3bd26ebaae4aa1f95129e5e54670f1",
                "a" ^ 1_000_000 => "34aa973cd4c4daa4f61eeb2bdbad27316534016f",)

for (text, expect) in testdict
    digest = hexdigest("sha1", text)
    if length(text) > 50 text = text[1:50] * "..." end
    println("# $text\n -> digest: $digest\n -> expect: $expect")
end
