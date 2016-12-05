// Define the thread if it doesn't exist
// New definition supersede any current threads.

not ::serverwide_singleton->istype
? define serverwide_singleton => thread {
    data public switch = 'x'
}

local(
    a = serverwide_singleton,
    b = serverwide_singleton,
)

#a->switch = 'a'
#b->switch = 'b'

#a->switch // b
