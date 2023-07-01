using Requests, Printf

function getusnotime()
    const url = "http://tycho.usno.navy.mil/timer.pl"
    s = try
        get(url)
        catch err
        @sprintf "get(%s)\n   => %s" url err
    end
    isa(s, Requests.Response) || return (s, false)
    t = match(r"(?<=<BR>)(.*?UTC)", readstring(s))
    isa(t, RegexMatch) || return (@sprintf("raw html:\n %s", readstring(s)), false)
    return (t.match, true)
end

(t, issuccess) = getusnotime();

if issuccess
    println("The USNO time is ", t)
else
    println("Failed to fetch UNSO time:\n", t)
end
