function unsafepointers()
    intspace = [42]
    address = pointer_from_objref(intspace)
    println("The address of intspace is $address")
    anotherint = unsafe_pointer_to_objref(address)
    println("intspace is $(intspace[1]), memory at $address, reference value $(anotherint[1])")
    intspace[1] = 123456
    println("Now, intspace is $(intspace[1]), memory at $address, reference value $(anotherint[1])")
    anotherint[1] = 7890
    println("Now, intspace is $(intspace[1]), memory at $(pointer_from_objref(anotherint)), reference value $(anotherint[1])")
end

unsafepointers()
