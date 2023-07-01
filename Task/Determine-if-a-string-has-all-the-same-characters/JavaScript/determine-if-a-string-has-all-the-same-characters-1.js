const check = s => {
  const arr = [...s];
  const at = arr.findIndex(
      (v, i) => i === 0 ? false : v !== arr[i - 1]
  )
  const l = arr.length;
  const ok = at === -1;
  const p = ok ? "" : at + 1;
  const v = ok ? "" : arr[at];
  const vs = v === "" ? v : `"${v}"`
  const h = ok ? "" : `0x${v.codePointAt(0).toString(16)}`;
  console.log(`"${s}" => Length:${l}\tSame:${ok}\tPos:${p}\tChar:${vs}\tHex:${h}`)
}

['', '   ', '2', '333', '.55', 'tttTTT', '4444 444k', '🐶🐶🐺🐶', '🎄🎄🎄🎄'].forEach(check)
