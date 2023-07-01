/* mac_vendor_lookup.wren */
class MAC {
    foreign static lookup(address)
}

System.print(MAC.lookup("FC:FB:FB:01:FA:21"))
for (i in 1..1e8) {} // slow down request
System.print(MAC.lookup("23:45:67"))
