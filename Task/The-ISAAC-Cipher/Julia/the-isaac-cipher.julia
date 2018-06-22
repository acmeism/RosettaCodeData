"""
Julia translation of code from the following:
------------------------------------------------------------------------------
readable.c: My random number generator, ISAAC.
(c) Bob Jenkins, March 1996, Public Domain
You may use this code in any way you wish, and it is free.  No warrantee.
------------------------------------------------------------------------------
"""
# maximum length of message here is set to 4096
const MAXMSG = 4096

# cipher modes for encryption versus decryption modes
@enum CipherMode mEncipher mDecipher mNone

# external results
mutable struct IState
    randrsl::Array{UInt32, 1}
    randcnt::UInt32
    mm::Array{UInt32, 1}
    aa::UInt32
    bb::UInt32
    cc::UInt32
    function IState()
        this = new()
        this.randrsl = zeros(UInt32, 256)
        this.randcnt = UInt32(0)
        this.mm = zeros(UInt32, 256)
        this.aa = this.bb = this.cc = UInt32(0)
        this
    end
end

"""
    isaac
Randomize the pool
"""
function isaac(istate)
    istate.cc +=  1             # cc gets incremented once per 256 results
    istate.bb += istate.cc      # then combined with bb

    for (j, c) in enumerate(istate.mm)   # Julia NB: indexing ahead so use i for c indexing
        i = j - 1
        xmod4 = i % 4
        if(xmod4 == 0)
            istate.aa ⊻= istate.aa << 13
        elseif(xmod4 == 1)
            istate.aa ⊻= istate.aa >> 6
        elseif(xmod4 == 2)
            istate.aa ⊻= istate.aa << 2
        else
            istate.aa ⊻= istate.aa >> 16
        end
        istate.aa += istate.mm[(i + 128) % 256 + 1]
        y = istate.mm[(c >> 2) % 256 + 1] + istate.aa + istate.bb
        istate.mm[j] = y
        istate.bb = istate.mm[(y >> 10) % 256 + 1] + c
        istate.randrsl[j] = istate.bb
    end
    # not in original readable.c
    istate.randcnt = 0
end


"""
    mix
Mix the bytes in a reversible way.
"""
function mix(arr)              # Julia NB: use E for e in c code here
   (a,b,c,d,E,f,g,h) = arr
   a⊻=b<<11; d+=a; b+=c;
   b⊻=c>>2;  E+=b; c+=d;
   c⊻=d<<8;  f+=c; d+=E;
   d⊻=E>>16; g+=d; E+=f;
   E⊻=f<<10; h+=E; f+=g;
   f⊻=g>>4;  a+=f; g+=h;
   g⊻=h<<8;  b+=g; h+=a;
   h⊻=a>>9;  c+=h; a+=b;
   (a,b,c,d,E,f,g,h)
end


"""
    randinit
Make a random UInt32 array.
If flag is true, use the contents of randrsl[] to initialize mm[].
"""
function randinit(istate, flag::Bool)
    istate.aa = istate.bb = istate.cc = 0
    mixer = Array{UInt32,1}(8)
    fill!(mixer, 0x9e3779b9)             # the golden ratio
    for i in 1:4                         # scramble it
        mixer = mix(mixer)
    end
    for i in 0:8:255                     # fill in mm[] with messy stuff
        if(flag)                         # use all the information in the seed
            mixer = [mixer[j] + istate.randrsl[i+j] for j in 1:8]
        end
        mixer = mix(mixer)
        istate.mm[i+1:i+8] .= mixer
    end
    if(flag)                             # do a second pass to seed all of mm
        for i in 0:8:255
            mixer = [mixer[j] + istate.mm[i+j] for j in 1:8]
            mixer = mix(mixer)
            istate.mm[i+1:i+8] .= mixer
        end
    end
    isaac(istate)                        # fill in the first set of results
    istate.randcnt = 0
end


"""
    Get a random 32-bit value 0..MAXINT
"""
function irandom(istate)
    retval::UInt32 = istate.randrsl[istate.randcnt+1]
    istate.randcnt += 1
    if(istate.randcnt > 255)
        isaac(istate)
        istate.randcnt = 0
    end
    retval
end


"""
    Get a random character in printable ASCII range
"""
iranda(istate) = UInt8(irandom(istate) % 95 + 32)


"""
    Do XOR cipher on random stream.
    Output: UInt8 array
"""
vernam(istate, msg) = [UInt8(iranda(istate) ⊻ c) for c in msg]


"""
    Seed ISAAC with a string
"""
function iseed(istate, seed, flag)
    fill!(istate.mm, 0)
    fill!(istate.randrsl, 0)
    len = min(length(seed), length(istate.randrsl))
    istate.randrsl[1:len] .= seed[1:len]
    randinit(istate, flag)   # initialize ISAAC with seed
end


tohexstring(arr::Array{UInt8,1}) = join([hex(i, 2) for i in arr])


function test(istate, msg, key)
    # Vernam ciphertext & plaintext
    vctx = zeros(UInt8, MAXMSG)
    vptx = zeros(UInt8, MAXMSG)
    # Encrypt: Vernam XOR
    iseed(istate, Vector{UInt8}(key), true)
    vctx = vernam(istate, Vector{UInt8}(msg))
    # Decrypt: Vernam XOR
    iseed(istate, Vector{UInt8}(key), true)
    vptx = vernam(istate, vctx)
    # Program output
    println("Message: $msg")
    println("Key    : $key")
    println("XOR    : $(tohexstring(vctx))")
    # Output Vernam decrypted plaintext
    println("XOR dcr: $(join(map(c -> Char(c), vptx)))")
    0
end


"""
Test the above.
"""
const msg = "a Top Secret secret"
const key = "this is my secret key"
test(IState(), msg, key)
