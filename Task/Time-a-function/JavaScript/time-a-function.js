function test() {
    let n = 0
    for(let i = 0; i < 1000000; i++){
        n += i
    }
}

let start = new Date().valueOf()
test()
let end = new Date().valueOf()

console.log('test() took ' + ((end - start) / 1000) + ' seconds') // test() took 0.001 seconds
