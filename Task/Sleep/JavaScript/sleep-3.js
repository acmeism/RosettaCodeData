function sleepFuriously(ms) {
    const start = Date.now()
    while (Date.now() - start < ms);
}

console.log('sleeping...')
sleepFuriously(1000)
console.log('wow, that was exhausting!')
