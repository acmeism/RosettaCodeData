# turn off garbage collector to prevent the Secret from being copied to a new page """
GC.enable(false)

""" struct Secret, contains a vector of Char that can be blanked with setzeros() """
struct Secret
    chars::Vector{Char}
    Secret(secret_length) = new(fill(Char(0), secret_length))
end

# set the memory in the Secret struct to zeros """
setzeros(s) = (fill!(s.chars, Char(0)); return s)

# Use C library character-based IO to prevent making julia immutable String """
getch() = ccall(:_getch, Cint, ())
putch(ch) = (ccall(:_putch, Cint, (UInt8,), ch); flush(stdout))


""" test the function """
function testsecret(maxlength = 32)
    print("Enter secret (up to $maxlength ascii chars): ")
    secret = Secret(maxlength)

    # keep track of the actual length of the entered Secret Char array
    slen = 0

    # entry of secret does not echo chars (unix password style)
    for _ in 1:maxlength
        ch = Char(getch())
        ch in ['\r', '\n'] && break
        slen += 1
        secret.chars[slen] = ch
    end

    # now display what was entered
    print("\nDisplaying secret: ")
    for i in 1:slen
        putch(secret.chars[i])
    end

    # destroy the secret
    print("\nDestroying secret... ")
    setzeros(secret)
    slen = 0 # zero out the length, which is on the stack for this function
    println("Secret is now: $secret.")
end

testsecret()
