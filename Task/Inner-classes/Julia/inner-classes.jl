""" see the Outer class in C++ example """
struct Outer
    m_privateField::Int

    """ Inner class in example """
    struct Inner
        m_innerValue::Int
    end
end

""" adds the values from the outer and inner class objects """
addouter(inner::Inner, outer::Outer) = outer.m_privateField + inner.m_innerValue

"""
    Test the functions. Iterables in Julia are structs for which the iterate()
    function is defined, so no need for inner classes for that
"""
function main()
    inner =  Inner(42)
    outer =  Outer(1)
    outplusin = addouter(inner, outer)
    println("sum: $outplusin")
end

main()
