console.log(`\
${'Character'.padEnd(16)}\
${'CodePoint'.padEnd(16)}\
${'CodeUnits'.padEnd(16)}\
${'uft8encode(ch)'.padEnd(16)}\
${'uft8encode(cp)'.padEnd(16)}\
utf8decode(cu)`)
for(let [ch,cp,cu] of inputs)
  console.log(`\
${ch.padEnd(16)}\
${cp.toString(0x10).padStart(8,'U+000000').padEnd(16)}\
${`[${[...cu].map(n=>n.toString(0x10))}]`.padEnd(16)}\
${`[${[...utf8encode(ch)].map(n=>n.toString(0x10))}]`.padEnd(16)}\
${`[${[...utf8encode(cp)].map(n=>n.toString(0x10))}]`.padEnd(16)}\
${utf8decode(cu).toString(0x10).padStart(8,'U+000000')}`)
