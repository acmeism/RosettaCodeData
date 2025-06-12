const date = new Date('2007-11-23T00:00:00Z')

const concise = date.toISOString().split('T', 1)[0]

const pretty = date.toLocaleString('en-US', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    timeZone: 'UTC',
})

console.log({ concise, pretty })
