function newEratoInf()
  local _cand = 0; local _lstbp = 3; local _lstsqr = 9
  local _composites = {}; local _bps = nil
  local _self = {}
  function _self.next()
    if _cand < 9 then if _cand < 1 then _cand = 1; return 2
                     elseif _cand >= 7 then
                       --advance aux source base primes to 3...
                       _bps = newEratoInf()
                       _bps.next(); _bps.next() end end
    _cand = _cand + 2
    if _composites[_cand] == nil then -- may be prime
      if _cand >= _lstsqr then -- if not the next base prime
        local adv = _lstbp + _lstbp -- if next base prime
        _composites[_lstbp * _lstbp + adv] = adv -- add cull seq
        _lstbp = _bps.next(); _lstsqr = _lstbp * _lstbp -- adv next base prime
        return _self.next()
      else return _cand end -- is prime
    else
      local v = _composites[_cand]
      _composites[_cand] = nil
      local nv = _cand + v
      while _composites[nv] ~= nil do nv = nv + v end
      _composites[nv] = v
      return _self.next() end
  end
  return _self
end

gen = newEratoInf()
count = 0
while gen.next() <= 10000000 do count = count + 1 end -- sieves to 10 million
print(count)
