package main

import (
    "go/build"
    "log"
    "path/filepath"

    "github.com/unixpickle/gospeech"
    "github.com/unixpickle/wav"
)

const pkgPath = "github.com/unixpickle/gospeech"
const input = "This is an example of speech synthesis."

func main() {
    p, err := build.Import(pkgPath, ".", build.FindOnly)
    if err != nil {
        log.Fatal(err)
    }
    d := filepath.Join(p.Dir, "dict/cmudict-IPA.txt")
    dict, err := gospeech.LoadDictionary(d)
    if err != nil {
        log.Fatal(err)
    }
    phonetics := dict.TranslateToIPA(input)
    synthesized := gospeech.DefaultVoice.Synthesize(phonetics)
    wav.WriteFile(synthesized, "output.wav")
}
