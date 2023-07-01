type SentenceType {.pure.} = enum Q, E, S, N

func sentenceType(s: string): SentenceType =
  ## Return the type of a sentence.
  if s.len == 0: return
  result = case s[^1]
           of '?': Q
           of '!': E
           of '.': S
           else: N

iterator sentences(text: string): string =
  ## Cut a text into sentences.
  var sentence = ""
  for ch in text:
    if ch == ' ' and sentence.len == 0: continue
    sentence.add ch
    if ch in "?!.":
      yield sentence
      sentence.reset()
  if sentence.len > 0:
    yield sentence


const Text = "hi there, how are you today? " &
             "I'd like to present to you the washing machine 9001. " &
             "You have been nominated to win one of these!" &
             "Just make sure you don't break it"

for sentence in Text.sentences():
  echo sentence, " → ", sentenceType(sentence)
