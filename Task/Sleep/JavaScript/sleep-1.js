function delay (ms) {
    return new Promise((res) => setTimeout(res, ms))
}

void (async () => {
    for (let i = 10; i > 0; --i) {
        console.log(i)
        await delay(1000)
    }
    console.log('Blast off!')
})()
