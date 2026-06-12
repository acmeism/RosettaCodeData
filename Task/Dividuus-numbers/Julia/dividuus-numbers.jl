digitalroot(n::Integer) = (r = sum(digits(n)); r < 10 ? r : digitalroot(r))

multiplicativedigitalroot(n::Integer) = (r = prod(digits(n)); r < 10 ? r : multiplicativedigitalroot(r))

#= """original isdividdus check"""
function isdividuus(n::Integer)::Bool
    d = digits(n)
    dr, pr = digitalroot(n), multiplicativedigitalroot(n)
    sd, pd = sum(d), prod(d)
    return dr != 0 && pr != 0 && n % sd == 0 && n % pd == 0 && n % dr == 0 && n % pr == 0
end
=#
function isdividuus(n::Integer)::Bool
    d = digits(n)
    pd = prod(d)
    if pd == 0 return 0 end
    if n % pd != 0 return 0 end
    sd = sum(d)
#   if sd == 0 return 0 end #sd starts at 1
    if n % sd != 0 return 0 end
    dr = digitalroot(n)
    if dr == 0 return 0 end
    if n % dr != 0 return 0 end
#   no need to start with n
    pr = multiplicativedigitalroot(pd)
    return pr != 0  && n % pr == 0
end
const dividuus = Int64[]
for i in 1:typemax(Int32)
    isdividuus(i) && push!(dividuus, i)
    length(dividuus) >= 50 && break
end
println("First fifty Dividuus numbers:\n", join(map(string, dividuus), ", "), "\n")
for i in 990_000_000:1_000_000_000
    isdividuus(i) && push!(dividuus, i)
end
println("Dividuus numbers between 990,000,000 and 1,000,000,000:")
println(join(map(string, dividuus[51:end]), ", "))
