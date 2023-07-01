sub half_add( byval a as ubyte, byval b as ubyte,_
              byref s as ubyte, byref c as ubyte)
    s = a xor b
    c = a and b
end sub

sub full_add( byval a as ubyte, byval b as ubyte, byval c as ubyte,_
              byref s as ubyte, byref g as ubyte )
    dim as ubyte x, y, z
    half_add( a, c, x, y )
    half_add( x, b, s, z )
    g = y or z
end sub

sub fourbit_add( byval a3 as ubyte, byval a2 as ubyte, byval a1 as ubyte, byval a0 as ubyte,_
                 byval b3 as ubyte, byval b2 as ubyte, byval b1 as ubyte, byval b0 as ubyte,_
                 byref s3 as ubyte, byref s2 as ubyte, byref s1 as ubyte, byref s0 as ubyte,_
                 byref carry as ubyte )
    dim as ubyte c2, c1, c0
    full_add(a0, b0,  0, s0, c0)
    full_add(a1, b1, c0, s1, c1)
    full_add(a2, b2, c1, s2, c2)
    full_add(a3, b3, c2, s3, carry )
end sub

dim as ubyte s3, s2, s1, s0, carry

print "1100 + 0011 = ";
fourbit_add( 1, 1, 0, 0,  0, 0, 1, 1,  s3, s2, s1, s0, carry )
print carry;s3;s2;s1;s0

print "1111 + 0001 = ";
fourbit_add( 1, 1, 1, 1,  0, 0, 0, 1,  s3, s2, s1, s0, carry )
print carry;s3;s2;s1;s0

print "1111 + 1111 = ";
fourbit_add( 1, 1, 1, 1,  1, 1, 1, 1,  s3, s2, s1, s0, carry )
print carry;s3;s2;s1;s0
