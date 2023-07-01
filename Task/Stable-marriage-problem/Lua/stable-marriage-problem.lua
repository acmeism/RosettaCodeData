local Person = {}
Person.__index = Person

function Person.new(inName)
    local o = {
        name            = inName,
        prefs           = nil,
        fiance          = nil,
        _candidateIndex = 1,
    }
    return setmetatable(o, Person)
end

function Person:indexOf(other)
    for i, p in pairs(self.prefs) do
        if p == other then return i end
    end
    return 999
end

function Person:prefers(other)
    return self:indexOf(other) < self:indexOf(self.fiance)
end

function Person:nextCandidateNotYetProposedTo()
    if self._candidateIndex >= #self.prefs then return nil end
    local c = self.prefs[self._candidateIndex];
    self._candidateIndex = self._candidateIndex + 1
    return c;
end

function Person:engageTo(other)
    if other.fiance then
        other.fiance.fiance = nil
    end
    other.fiance = self
    if self.fiance then
        self.fiance.fiance = nil
    end
    self.fiance = other;
end

local function isStable(men)
    local women = men[1].prefs
    local stable = true
    for _, guy in pairs(men) do
        for _, gal in pairs(women) do
            if guy:prefers(gal) and gal:prefers(guy) then
                stable = false
                print(guy.name .. ' and ' .. gal.name ..
                      ' prefer each other over their partners ' ..
                      guy.fiance.name .. ' and ' .. gal.fiance.name)
            end
        end
    end
    return stable
end

local abe  = Person.new("Abe")
local bob  = Person.new("Bob")
local col  = Person.new("Col")
local dan  = Person.new("Dan")
local ed   = Person.new("Ed")
local fred = Person.new("Fred")
local gav  = Person.new("Gav")
local hal  = Person.new("Hal")
local ian  = Person.new("Ian")
local jon  = Person.new("Jon")

local abi  = Person.new("Abi")
local bea  = Person.new("Bea")
local cath = Person.new("Cath")
local dee  = Person.new("Dee")
local eve  = Person.new("Eve")
local fay  = Person.new("Fay")
local gay  = Person.new("Gay")
local hope = Person.new("Hope")
local ivy  = Person.new("Ivy")
local jan  = Person.new("Jan")

abe.prefs  = { abi,  eve,  cath, ivy,  jan,  dee,  fay,  bea,  hope, gay  }
bob.prefs  = { cath, hope, abi,  dee,  eve,  fay,  bea,  jan,  ivy,  gay  }
col.prefs  = { hope, eve,  abi,  dee,  bea,  fay,  ivy,  gay,  cath, jan  }
dan.prefs  = { ivy,  fay,  dee,  gay,  hope, eve,  jan,  bea,  cath, abi  }
ed.prefs   = { jan,  dee,  bea,  cath, fay,  eve,  abi,  ivy,  hope, gay  }
fred.prefs = { bea,  abi,  dee,  gay,  eve,  ivy,  cath, jan,  hope, fay  }
gav.prefs  = { gay,  eve,  ivy,  bea,  cath, abi,  dee,  hope, jan,  fay  }
hal.prefs  = { abi,  eve,  hope, fay,  ivy,  cath, jan,  bea,  gay,  dee  }
ian.prefs  = { hope, cath, dee,  gay,  bea,  abi,  fay,  ivy,  jan,  eve  }
jon.prefs  = { abi,  fay,  jan,  gay,  eve,  bea,  dee,  cath, ivy,  hope }

abi.prefs  = { bob,  fred, jon,  gav,  ian,  abe,  dan,  ed,   col,  hal  }
bea.prefs  = { bob,  abe,  col,  fred, gav,  dan,  ian,  ed,   jon,  hal  }
cath.prefs = { fred, bob,  ed,   gav,  hal,  col,  ian,  abe,  dan,  jon  }
dee.prefs  = { fred, jon,  col,  abe,  ian,  hal,  gav,  dan,  bob,  ed   }
eve.prefs  = { jon,  hal,  fred, dan,  abe,  gav,  col,  ed,   ian,  bob  }
fay.prefs  = { bob,  abe,  ed,   ian,  jon,  dan,  fred, gav,  col,  hal  }
gay.prefs  = { jon,  gav,  hal,  fred, bob,  abe,  col,  ed,   dan,  ian  }
hope.prefs = { gav,  jon,  bob,  abe,  ian,  dan,  hal,  ed,   col,  fred }
ivy.prefs  = { ian,  col,  hal,  gav,  fred, bob,  abe,  ed,   jon,  dan  }
jan.prefs  = { ed,   hal,  gav,  abe,  bob,  jon,  col,  ian,  fred, dan  }

local men = abi.prefs
local freeMenCount = #men
while freeMenCount > 0 do
    for _, guy in pairs(men) do
        if not guy.fiance then
            local gal = guy:nextCandidateNotYetProposedTo()
            if not gal.fiance then
                guy:engageTo(gal)
                freeMenCount = freeMenCount - 1
            elseif gal:prefers(guy) then
                guy:engageTo(gal)
            end
        end
    end
end

print(' ')
for _, guy in pairs(men) do
    print(guy.name .. ' is engaged to ' .. guy.fiance.name)
end
print('Stable: ', isStable(men))

print(' ')
print('Switching ' .. fred.name .. "'s & " .. jon.name .. "'s partners")
jon.fiance, fred.fiance = fred.fiance, jon.fiance
print('Stable: ', isStable(men))
