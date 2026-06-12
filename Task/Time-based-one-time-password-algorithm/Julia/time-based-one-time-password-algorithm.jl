using CodecBase
using SHA

function hmac(key, msg, hashfunction, blocksize=64)
    key = hashfunction(key)
    paddingneeded = blocksize - length(key)
    if paddingneeded > 0
        resize!(key, blocksize)
        key[end-paddingneeded+1:end] .= 0
    end
    return hashfunction([key .⊻ 0x5c; hashfunction([key .⊻ 0x36; msg])])
end

#see also https://github.com/ylxdzsw/TOTP.jl
hmac(hashfunc, bs=64) = (key, msg, blocksize=bs) -> hmac(key, msg, hashfunc, blocksize)

function genotp(secret::String; tokenlength=6, hashfunc=hmac(sha1), tim=time()/30, outbase=10)
    message = (([UInt8((Int(floor(tim)) >> 8i) & 0xff) for i in 7:-1:0]))
    msghash = hashfunc(secret, message)

    offset = msghash[length(msghash)] & 0x0f
    binary = (Int(msghash[offset+1] & 0x7f) << 24) |
             (Int(msghash[offset+2] & 0xff) << 16) |
             (Int(msghash[offset+3] & 0xff) << 8) |
             (msghash[offset+4] & 0xff)
    otp = binary % outbase^tokenlength
    string(otp, pad=tokenlength, base=outbase)
end

function genopt_fromb32(secret32; kwargs...)
    secret = transcode(Base32Decoder(), secret32)
    return genotp(secret; kwargs...)
end

for i in 1:7
    println(genotp("JBSWY3DPEHPK3PXP"))
    sleep(15)
end
