# Save this section as a file called query.jl

function Query(buffer::Ptr{UInt8}, length::Ptr{Csize_t})::Cint
    """ Define the Query function to be called from C """

    max_size = unsafe_load(length)
    data = "Hello from Julia!"
    bytes = codeunits(data)
    max_size < length(bytes) && return 0  # Failure: buffer too small
    for i in 1:length(bytes)
        unsafe_store!(buffer, bytes[i], i)
    end
    unsafe_store!(length, length(bytes))
    return 1
end

Base.@export Query
