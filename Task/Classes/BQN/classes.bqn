ExClass ← {
  𝕊 value: # Constructor portion
  priv ← value
  priv2 ⇐ 0
  ChangePriv ⇐ { priv ↩ 𝕩 }
  DispPriv ⇐ {𝕊: •Show priv‿priv2 }

}

obj ← ExClass 5
obj.DispPriv@
obj.ChangePriv 6
obj.DispPriv@
