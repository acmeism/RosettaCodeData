using Nettle

function Base.trunc(s::AbstractString, n::Integer)
    n > 0 || throw(DomainError())
    l = length(s)
    l > n || return s
    n > 3 || return s[1:n]
    return s[1:n-3] * "..."
end

tests = [""    => "d41d8cd98f00b204e9800998ecf8427e",
         "a"   => "0cc175b9c0f1b6a831c399e269772661",
         "abc" => "900150983cd24fb0d6963f7d28e17f72",
         "message digest" => "f96b697d7cb7938d525a2f31aaf161d0",
         "abcdefghijklmnopqrstuvwxyz" => "c3fcd3d76192e4007dfb496cca67e13b",
         "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789" =>
         "d174ab98d277d9f5a5611c2c9f419d9f",
         "12345678901234567890123456789012345678901234567890123456789012345678901234567890" =>
         "57edf4a22be3c955ac49da2e2107b67a",
         "foobad" => "3858f62230ac3c915f300c664312c63f"]

println("Testing Julia's MD5 hash against RFC 1321.")
for (k, h) in sort(tests, by = length ∘ first)
    md5sum = hexdigest("md5", k)
    @printf("%20s → %s ", trunc(k, 15), md5sum)
    if md5sum == h
        println("MD5 OK")
    else
        println("MD5 Bad")
        println("* The sum should be  ", h)
    end
end
