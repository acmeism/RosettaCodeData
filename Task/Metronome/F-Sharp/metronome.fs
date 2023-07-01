open System
open System.Threading
// You can use .wav files for your clicks.
// If used, make sure they are in the same file
// as this program's executable file.
let high_pitch =
    new System.Media.SoundPlayer("Ping Hi.wav")
let low_pitch =
    new System.Media.SoundPlayer("Ping Low.wav")
let factor x y = x / y
// Notice that exact bpm would not work by using
// Thread.Sleep() as there are additional function calls
// that would consume a miniscule amount of time.
// This number may need to be adjusted based on the cpu.
let cpu_error = -750.0
let print = function
| 1 -> high_pitch.Play(); printf "\nTICK "
| _ -> low_pitch.Play(); printf "tick "
let wait (time:int) =
    Thread.Sleep(time)
// Composition of functions
let tick = float>>factor (60000.0+cpu_error)>>int>>wait
let rec play beats_per_measure current_beat beats_per_minute =
    match current_beat, beats_per_measure with
    | a, b ->
        current_beat |> print
        beats_per_minute |> tick
        if a <> b then
            beats_per_minute |> play beats_per_measure (current_beat + 1)
[<EntryPointAttribute>]
let main (args : string[]) =
    let tempo, beats = int args.[0], int args.[1]
    Seq.initInfinite (fun i -> i + 1)
    |> Seq.iter (fun _ -> tempo |> play beats 1 |> ignore)
    0
