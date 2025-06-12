const SEMITONE = 2 ** (1 / 12)

function incrementSemitones(root) {
    return (n) => root * SEMITONE ** n
}

function playNotes(root, notes, { seconds, wave } = {}) {
    const ctx = new AudioContext()
    const oscillator = ctx.createOscillator()
    const freqs = notes.map(incrementSemitones(root))

    oscillator.connect(ctx.createGain().connect(ctx.destination))
    oscillator.type = wave ?? 'sine'

    const duration = seconds ?? 0.3

    for (const [i, freq] of freqs.entries()) {
        oscillator.frequency.setValueAtTime(freq, ctx.currentTime + i * duration)
    }

    oscillator.start()
    oscillator.stop(ctx.currentTime + freqs.length * duration)

    return new Promise((res) => oscillator.addEventListener('ended', res))
}

const A = 440
const C = incrementSemitones(A)(-9) // ~= 261.63

const major = [0, 2, 4, 5, 7, 9, 11, 12]
const minor = [0, 2, 3, 5, 7, 8, 10, 12]

void (async function main() {
    await playNotes(C, major, { seconds: 0.3, wave: 'sine' })
    await playNotes(A, minor, { seconds: 0.1, wave: 'triangle' })
})()
