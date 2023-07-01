SetPrototype = {
    __index = {
        union = function(self, other)
            local res = Set{}
            for k in pairs(self) do res[k] = true end
            for k in pairs(other) do res[k] = true end
            return res
        end,
        intersection = function(self, other)
            local res = Set{}
            for k in pairs(self) do res[k] = other[k] end
            return res
        end,
        difference = function(self, other)
            local res = Set{}
            for k in pairs(self) do
                if not other[k] then res[k] = true end
            end
            return res
        end,
        symmetric_difference = function(self, other)
            return self:difference(other):union(other:difference(self))
        end
    },
    -- return string representation of set
    __tostring = function(self)
        -- list to collect all elements from the set
        local l = {}
        for k in pairs(self) do l[#l+1] = k end
        return "{" .. table.concat(l, ", ") .. "}"
    end,
    -- allow concatenation with other types to yield string
    __concat = function(a, b)
        return (type(a) == 'string' and a or tostring(a)) ..
            (type(b) == 'string' and b or tostring(b))
    end
}

function Set(items)
    local _set = {}
    setmetatable(_set, SetPrototype)
    for _, item in ipairs(items) do _set[item] = true end
    return _set
end

A = Set{"John", "Serena", "Bob", "Mary", "Serena"}
B = Set{"Jim", "Mary", "John", "Jim", "Bob"}

print("Set A: " .. A)
print("Set B: " .. B)

print("\nSymm. difference (A\\B)∪(B\\A): " .. A:symmetric_difference(B))
print("Union            A∪B        : " .. A:union(B))
print("Intersection     A∩B        : " .. A:intersection(B))
print("Difference       A\\B        : " .. A:difference(B))
print("Difference       B\\A        : " .. B:difference(A))
