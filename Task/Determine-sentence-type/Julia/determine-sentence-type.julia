const text = """
Hi there, how are you today? I'd like to present to you the washing machine 9001.
You have been nominated to win one of these! Just make sure you don't break it"""

haspunctotype(s) = '.' in s ? "S" : '!' in s ? "E" : '?' in s ? "Q" : "N"

text = replace(text, "\n" => " ")
parsed = strip.(split(text, r"(?:(?:(?<=[\?\!\.])(?:))|(?:(?:)(?=[\?\!\.])))"))
isodd(length(parsed)) && push!(parsed, "")  # if ends without pnctuation
for i in 1:2:length(parsed)-1
    println(rpad(parsed[i] * parsed[i + 1], 52),  " ==> ", haspunctotype(parsed[i + 1]))
end
