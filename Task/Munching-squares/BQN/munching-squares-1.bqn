nl←@+10
XORppm ← {
  g←⥊(0∾∾˜)¨((↕𝕩)16‿16•bit._xor⊢)˘↕𝕩
  s←•Repr 𝕩
  h←"P3"∾nl∾s∾" "∾s∾nl∾(•Repr 𝕩-1)∾nl
  h∾∾∾⟜nl¨{¯1↓∾∾⟜' '¨•Repr¨𝕩}¨g
}
