types = [Bool, Char, Int8, UInt8, Int16, UInt16, Int32, UInt32, Int64, UInt64]

for t in types
    println("For type ", lpad(t,6), " size is $(sizeof(t)) 8-bit bytes, or ",
        lpad(string(8*sizeof(t)), 2), " bits.")
end

primitive type MyInt24 24 end

println("\nFor the 24-bit user defined type MyInt24, size is ", sizeof(MyInt24), " bytes.")
