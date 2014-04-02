process.openStdin().on (
    'data',
    function (line) {
        var xs = String(line).match(/^\s*(\d+)\s+(\d+)\s*/)
        console.log (
            xs ? Number(xs[1]) + Number(xs[2]) : 'usage: <number> <number>'
        )
        process.exit()
    }
)
