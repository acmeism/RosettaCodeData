    julia> function testme()
       ui8::UInt8 = 1
       ui16::UInt16 = ui8
       ui32::UInt32 = ui8
       ui64::UInt64 = ui8
       flo::Float64 = ui8
       return ui8, sizeof(ui8), ui16, sizeof(ui16), ui32, sizeof(ui32), ui64, sizeof(ui64), flo, sizeof(flo)
       end
    testme (generic function with 1 method)

    julia> testme()
    (0x01, 1, 0x0001, 2, 0x00000001, 4, 0x0000000000000001, 8, 1.0, 8)
