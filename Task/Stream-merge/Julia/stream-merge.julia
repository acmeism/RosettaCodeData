function merge(stream1, stream2, T=Char)
    if !eof(stream1) && !eof(stream2)
        b1 = read(stream1, T)
        b2 = read(stream2, T)
        while !eof(stream1) && !eof(stream2)
            if b1 <= b2
                print(b1)
                if !eof(stream1)
                    b1 = read(stream1, T)
                end
            else
                print(b2)
                if !eof(stream2)
                    b2 = read(stream2, T)
                end
            end
        end
        while !eof(stream1)
            print(b1)
            b1 = read(stream1, T)
        end
        print(b1)
        while !eof(stream2)
            print(b2)
            b2 = read(stream2, T)
        end
        print(b2)
    end
end

const halpha1 = "acegikmoqsuwy"
const halpha2 = "bdfhjlnprtvxz"
const buf1 = IOBuffer(halpha1)
const buf2 = IOBuffer(halpha2)

merge(buf1, buf2, Char)
println("\nDone.")
