function Verify(filename)
    print(filename
        , os.rename(filename, filename) and "exists" or "void"
    )
end

for _, v in ipairs{"input.txt","docs"} do
   Verify("/" .. v)
   Verify(v)
end
