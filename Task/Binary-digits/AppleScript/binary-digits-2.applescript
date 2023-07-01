-- showBin :: Int -> String
on showBin(n)
    script binaryChar
        on |λ|(n)
            text item (n + 1) of "〇一"
        end |λ|
    end script
    showIntAtBase(2, binaryChar, n, "")
end showBin
