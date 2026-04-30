Add-Type -AssemblyName System.Speech

$anna = New-Object System.Speech.Synthesis.SpeechSynthesizer

$anna.Speak("I'm sorry Dave, I'm afraid I can't do that.")
$anna.Dispose()
