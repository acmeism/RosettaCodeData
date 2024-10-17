import Base.show, Base.parse, Base.+, Base.-, Base.*, Base./, Base.^

function inbase4(charvec::Vector)
    if (!all(x -> x in ['-', '0', '1', '2', '3', '.'], charvec)) ||
        ((x = findlast(x -> x == '-', charvec)) != nothing && x > findfirst(x -> x != '-', charvec)) ||
        ((x = findall(x -> x == '.', charvec)) != nothing && length(x) > 1)
        return false
    end
    true
end
inbase4(s::String) = inbase4(split(s, ""))

abstract type ImaginaryBaseNumber <: Number end

struct QuaterImaginary <: ImaginaryBaseNumber
    cvector::Vector{Char}
    isnegative::Bool
end

function QuaterImaginary(charvec::Vector{Char})
    isneg = false
    if !inbase4(charvec)
        throw("Constructor vector for QuaterImaginary ($charvec) is not base 2i")
    elseif (i = length(findall(x -> x == '-', charvec))) > 0
        isneg = (-1) ^ i == -1
    end
    while length(charvec) > 1 && charvec[1] == '0' && charvec[2] != '.'
        popfirst!(charvec)
    end
    if (i = findfirst(x -> x == '.', charvec)) != nothing
        while length(charvec) > 3 && charvec[end] == '0' && charvec[end-1] != '.'
            pop!(charvec)
        end
    end
    if charvec[1] == '.'
            pushfirst!(charvec, '0')
    end
    if charvec[end] == '.'
        pop!(charvec)
    end
    QuaterImaginary(filter!(x -> x in ['0', '1', '2', '3', '.'], charvec), isneg)
end

function QuaterImaginary(s::String = "0")
    if match(r"^-?[0123\.]+$", s) == nothing
        throw("String constructor argument <$s> for QuaterImaginary is not base 2i")
    end
    QuaterImaginary([s[i] for i in 1:length(s)])
end

show(io::IO, qim::QuaterImaginary) = print(io, qim.isnegative ? "-" : "", join(qim.cvector, ""))

function parse(QuaterImaginary, x::Complex)
    sb = Vector{Char}()
    rea, ima = Int(floor(real(x))), Int(floor(imag(x)))
    if floor(real(x)) != rea || floor(imag(x)) != ima
        throw("Non-integer real and complex portions of complex numbers are not supported for QuaterImaginary")
    elseif rea == 0 == ima
        return QuaterImaginary(['0'])
    else
        fi = -1
        while rea != 0
            rea, rem = divrem(rea, -4)
            if rem < 0
                rem += 4
                rea += 1
            end
            push!(sb, Char(rem + '0'), '0')
        end
        if ima != 0
            f = real((ima * im)/(2im))
            ima = Int(ceil(f))
            f = -4.0 * (f - ima)
            idx = 1
            while ima != 0
                ima, rem = divrem(ima, -4)
                if rem < 0
                    rem += 4
                    ima += 1
                end
                if idx < length(sb)
                    sb[idx + 1] = Char(rem + '0')
                else
                    push!(sb, '0', Char(rem + '0'))
                end
                idx += 2
            end
            fi = Int(floor(f))
        end
        sb = reverse(sb)
        if fi != -1
            push!(sb, '.')
            append!(sb, map(x -> x[1], split(string(fi), "")))
        end
    end
    QuaterImaginary(sb)
end

function parse(Complex, qim::QuaterImaginary)
    pointpos = ((x = indexin('.', qim.cvector))[1] == nothing) ? -1 : x[1]
    poslen = (pointpos != -1) ? pointpos : length(qim.cvector) + 1
    qsum = 0.0 + 0.0im
    prod = 1.0 + 0.0im
    for j in 1:poslen-1
        k = Float64(qim.cvector[poslen - j] - '0')
        if k > 0.0
            qsum += prod * k
        end
        prod *= 2im
    end
    if pointpos != -1
        prod = inv(2im)
        for j in poslen+1:length(qim.cvector)
            k = Float64(qim.cvector[j] - '0')
            if k > 0.0
                qsum += prod * k
            end
            prod *= inv(2im)
        end
    end
    qsum
end

function testquim()
    function printcqc(c)
        q = parse(QuaterImaginary, Complex(c))
        c2 = parse(Complex, q)
        if imag(c2) == 0
            c2 = Int(c2)
        end
        print(lpad(c, 10), " -> ", lpad(q, 10), " -> ", lpad(c2, 12))
    end
    for i in 1:16
        printcqc(i)
        print("       ")
        printcqc(-i)
        println()
    end
    println()
    for i in 1:16
        c1 = Complex(0, i)
        printcqc(c1)
        print("       ")
        printcqc(-c1)
        println()
    end
end

QuaterImaginary(c::Complex) = parse(QuaterImaginary, c)
Complex(q::QuaterImaginary) = parse(Complex, q)

+(q1::QuaterImaginary, q2::QuaterImaginary) = QuaterImaginary(Complex(q1) + Complex(q2))
+(q1::Complex, q2::QuaterImaginary) = q1 + Complex(q2)
+(q1::QuaterImaginary, q2::Complex) = Complex(q1) + q2
-(q1::QuaterImaginary, q2::QuaterImaginary) = QuaterImaginary(Complex(q1) - Complex(q2))
-(q1::Complex, q2::QuaterImaginary) = q1 - Complex(q2)
-(q1::QuaterImaginary, q2::Complex) = Complex(q1) - q2
*(q1::QuaterImaginary, q2::QuaterImaginary) = QuaterImaginary(Complex(q1) * Complex(q2))
*(q1::Complex, q2::QuaterImaginary) = q1 * Complex(q2)
*(q1::QuaterImaginary, q2::Complex) = Complex(q1) * q2
/(q1::QuaterImaginary, q2::QuaterImaginary) = QuaterImaginary(Complex(q1) / Complex(q2))
/(q1::Complex, q2::QuaterImaginary) = q1 / Complex(q2)
/(q1::QuaterImaginary, q2::Complex) = Complex(q1) / q2
^(q1::QuaterImaginary, q2::QuaterImaginary) = QuaterImaginary(Complex(q1) ^ Complex(q2))
^(q1::Complex, q2::QuaterImaginary) = q1 ^ Complex(q2)
^(q1::QuaterImaginary, q2::Complex) = Complex(q1) ^ q2

testquim()
