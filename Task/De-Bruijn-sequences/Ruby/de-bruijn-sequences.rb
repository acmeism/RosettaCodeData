def deBruijn(k, n)
    alphabet = "0123456789"
    @a = Array.new(k * n, 0)
    @seq = []

    def db(k, n, t, p)
        if t > n then
            if n % p == 0 then
                temp = @a[1 .. p]
                @seq.concat temp
            end
        else
            @a[t] = @a[t - p]
            db(k, n, t + 1, p)
            j = @a[t - p] + 1
            while j < k do
                @a[t] = j # & 0xFF
                db(k, n, t + 1, t)
                j = j + 1
            end
        end
    end
    db(k, n, 1, 1)

    buf = ""
    for i in @seq
        buf <<= alphabet[i]
    end
    return buf + buf[0 .. n-2]
end

def validate(db)
    le = db.length
    found = Array.new(10000, 0)
    errs = []
    # Check all strings of 4 consecutive digits within 'db'
    # to see if all 10,000 combinations occur without duplication.
    for i in 0 .. le-4
        s = db[i .. i+3]
        if s.scan(/\D/).empty? then
            found[s.to_i] += 1
        end
    end
    for i in 0 .. found.length - 1
        if found[i] == 0 then
            errs <<= ("    PIN number %04d missing" % [i])
        elsif found[i] > 1 then
            errs <<= ("    PIN number %04d occurs %d times" % [i, found[i]])
        end
    end
    if errs.length == 0 then
        print "  No errors found\n"
    else
        pl = (errs.length == 1) ? "" : "s"
        print "  ", errs.length, " error", pl, " found:\n"
        for err in errs
            print err, "\n"
        end
    end
end

db = deBruijn(10, 4)
print "The length of the de Bruijn sequence is ", db.length, "\n\n"
print "The first 130 digits of the de Bruijn sequence are: ", db[0 .. 129], "\n\n"
print "The last 130 digits of the de Bruijn sequence are: ", db[-130 .. db.length], "\n\n"

print "Validating the de Bruijn sequence:\n"
validate(db)
print "\n"

db[4443] = '.'
print "Validating the overlaid de Bruijn sequence:\n"
validate(db)
