function countunicode()
    englishlettercodes = [Int(c) for c in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"]
    count = 0
    az = ""
    AZ = ""
    for i in 0:0xffffff
        if is_assigned_char(i)
            count += 1
        end
        if i in englishlettercodes
            c = Char(i)
            if islower(c)
                az *= "$c"
            else
                AZ *= "$c"
            end
        end
    end
    count, az, AZ
end

unicodecount, lcletters, ucletters = countunicode()

print("There are $unicodecount valid Chars and the English ones are ")
println("lowercase: $lcletters and uppercase: $ucletters.")
