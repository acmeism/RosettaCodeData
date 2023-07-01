// Define thread level singleton

define singleton => type {
    data public switch = 'x'
    public oncreate => var(.type)->isa(.type) ? var(.type) | var(.type) := self
}

local(
    a = singleton,
    b = singleton,
)

#a->switch = 'a'
#b->switch = 'b'

#a->switch // b
