function fmt(n, options) {
    const [whole, fraction] = String(n).split('.', 2)
    return [
        whole.padStart(options.whole || 1, '0'),
        (fraction ?? '').padEnd(options.fraction, '0').slice(0, options.fraction),
    ].filter(Boolean).join('.')
}

for (const [n, options] of [
    [123, { whole: 1, fraction: 2 }], // 123.00
    [123, { whole: 5, fraction: 2 }], // 00123.00
    [123, { whole: 5, fraction: 0 }], // 00123
    [0.5, { whole: 1, fraction: 2 }], // 0.50
    [0.5, { whole: 5, fraction: 2 }], // 00000.50
    [0.5, { whole: 5, fraction: 0 }], // 00000
]) {
    console.log(fmt(n, options))
}
