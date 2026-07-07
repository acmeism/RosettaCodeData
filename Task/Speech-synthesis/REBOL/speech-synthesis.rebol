Rebol [
    title: "Rosetta code: Speech synthesis"
    file:  %Speech_synthesis.r3
    url:   https://rosettacode.org/wiki/Speech_synthesis
]

print "Using Speak native extension."
print https://github.com/Oldes/Rebol-Speak
unless attempt [speak: import speak][
    print "Speak extension is not available!"
    quit
]

speak/list-voices

;; do some test with the extension
say {
<emph> boo </emph>! boo!
<rate absspeed="5">
   This text should be spoken at rate five.
   <rate absspeed="-5">
      This text should be spoken at rate negative five.
   </rate>
</rate>
<rate absspeed="10"/>}

say "This sounds normal <pitch middle = '-10'/> but the pitch drops half way through"

eva: say/as/no-wait "<rate speed='2'/>" 2
say/as "How are you? <pitch middle='-10'/> How are you?<pitch absmiddle='+10'/>How are you?" :eva
say/as "<pitch absmiddle='-10'/>This is a good day." :eva
esp: say/as "Holla muchachos! Pobre amigos." 3
