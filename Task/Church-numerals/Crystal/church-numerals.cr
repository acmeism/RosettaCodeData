struct Church # can't be generic!
  getter church : (Church -> Church) | Int32
  def initialize(@church) end
  def apply(ch)
    chf = @church
    chf.responds_to?(:call) ? chf.call(ch) : self
  end
  def compose(chr)
    chlf = @church
    chrf = chr.church
    if chlf.responds_to?(:call) && chrf.responds_to?(:call)
      Church.new(-> (f : Church) { chlf.call(chrf.call(f)) })
    else
      self
    end
  end
end

# Church Numeral constants...
CHURCH_ZERO = begin
  Church.new(-> (f : Church) {
    Church.new(-> (x : Church) { x }) })
end

CHURCH_ONE = begin
  Church.new(-> (f : Church) { f })
end

# Church Numeral functions...
def succChurch
  -> (ch : Church) {
        Church.new(-> (f : Church) { f.compose(ch.apply(f)) }) }
end

def addChurch
  -> (cha : Church, chb : Church) {
        Church.new(-> (f : Church) { cha.apply(f).compose(chb.apply(f)) }) }
end

def multChurch
  -> (cha : Church, chb : Church) { cha.compose(chb) }
end

def expChurch
  -> (chbs : Church, chexp : Church) { chexp.apply(chbs) }
end

def isZeroChurch
  liftZero = Church.new(-> (f : Church) { CHURCH_ZERO })
  -> (ch : Church) { ch.apply(liftZero).apply(CHURCH_ONE) }
end

def predChurch
  -> (ch : Church) {
    Church.new(-> (f : Church) { Church.new(-> (x : Church) {
          prd = Church.new(-> (g : Church) { Church.new(-> (h : Church) {
                  h.apply(g.apply(f)) }) })
          frst = Church.new(-> (d : Church) { x })
          id = Church.new(-> (a : Church) { a })
          ch.apply(prd).apply(frst).apply(id)
      }) }) }
end

def subChurch
  -> (cha : Church, chb : Church) {
    chb.apply(Church.new(predChurch)).apply(cha) }
end

def divr # can't be nested in another def...
  -> (n : Church, d: Church) {
    tstr = -> (v : Church) {
      loopr = Church.new(-> (a : Church) {
        succChurch.call(divr.call(v, d)) }) # recurse until zero
      v.apply(loopr).apply(CHURCH_ZERO) }
    tstr.call(subChurch.call(n, d)) }
end

def divChurch
  -> (chdvdnd : Church, chdvsr : Church) {
        divr.call(succChurch.call(chdvdnd), chdvsr) }
end

# conversion functions...
def intToChurch(i) : Church
  rslt = CHURCH_ZERO
  cntr = 0
  while cntr < i
    rslt = succChurch.call(rslt)
    cntr += 1
  end
  rslt
end

def churchToInt(ch) : Int32
  succInt32 = Church.new(-> (v : Church) {
    vi = v.church
    vi.is_a?(Int32) ? Church.new(vi + 1) : v })
  rslt = ch.apply(succInt32).apply(Church.new(0)).church
  rslt.is_a?(Int32) ? rslt : -1
end

# testing...
ch3 = intToChurch(3)
ch4 = succChurch.call(ch3)
ch11 = intToChurch(11)
ch12 = succChurch.call(ch11)
add = churchToInt(addChurch.call(ch3, ch4))
mult = churchToInt(multChurch.call(ch3, ch4))
exp1 = churchToInt(expChurch.call(ch3, ch4))
exp2 = churchToInt(expChurch.call(ch4, ch3))
iszero1 = churchToInt(isZeroChurch.call(CHURCH_ZERO))
iszero2 = churchToInt(isZeroChurch.call(ch3))
pred1 = churchToInt(predChurch.call(ch4))
pred2 = churchToInt(predChurch.call(CHURCH_ZERO))
sub = churchToInt(subChurch.call(ch11, ch3))
div1 = churchToInt(divChurch.call(ch11, ch3))
div2 = churchToInt(divChurch.call(ch12, ch3))
print("#{add} #{mult} #{exp1} #{exp2} #{iszero1} #{iszero2} ")
print("#{pred1} #{pred2} #{sub} #{div1} #{div2}\r\n")
