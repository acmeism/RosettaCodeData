T = { name=function(s) return "T" end, tostring=function(s) return "I am a "..s:name() end }

function clone(s) local t={} for k,v in pairs(s) do t[k]=v end return t end
S1 = clone(T)  S1.name=function(s) return "S1" end

function merge(s,t) for k,v in pairs(t) do s[k]=v end return s end
S2 = merge(clone(T), {name=function(s) return "S2" end})

function prototype(base,mixin) return merge(merge(clone(base),mixin),{prototype=base}) end
S3 = prototype(T, {name=function(s) return "S3" end})

print("T :  "..T:tostring())
print("S1:  " ..S1:tostring())
print("S2:  " ..S2:tostring())
print("S3:  " ..S3:tostring())
print("S3's parent:  "..S3.prototype:tostring())
