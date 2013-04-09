create cstr1 ," A sample string"
create cstr2 ," another string"
create buf 256 allot

cstr1 count buf place
s"  and " buf +place
cstr2 count buf +place
buf count type   \ A sample string and another string
