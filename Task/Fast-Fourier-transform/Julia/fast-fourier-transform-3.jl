function fft(a)
    y1 = Any[]; y2 = Any[]
    n = length(a)
    if n ==1 return a end
    wn(n) = exp(-2*π*im/n)
    y_even = fft(a[1:2:end])
    y_odd = fft(a[2:2:end])
    w = 1
    for k in 1:Int(n/2)
        push!(y1, y_even[k] + w*y_odd[k])
        push!(y2, y_even[k] - w*y_odd[k])
        w = w*wn(n)
    end
    return vcat(y1,y2)
end
