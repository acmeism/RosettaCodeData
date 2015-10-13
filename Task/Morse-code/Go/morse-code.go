// Command morse translates an input string into morse code,
// showing the output on the console, and playing it as sound.
// Only works on ubuntu.
package main

import (
	"flag"
	"fmt"
	"log"
	"regexp"
	"strings"
	"syscall"
	"time"
	"unicode"
)

// A key represents an action on the morse key.
// It's either on or off, for the given duration.
type key struct {
	duration int
	on       bool
	sym      string // for debug output
}

var (
	runeToKeys   = map[rune][]key{}
	interCharGap = []key{{1, false, ""}}
	punctGap     = []key{{7, false, " / "}}
	charGap      = []key{{3, false, " "}}
	wordGap      = []key{{7, false, " / "}}
)

const rawMorse = `
A:.-    J:.---  S:...    1:.----  .:.-.-.-  ::---...
B:-...  K:-.-   T:-      2:..---  ,:--..--  ;:-.-.-.
C:-.-.  L:.-..  U:..-    3:...--  ?:..--..  =:-...-
D:-..   M:--    V:...-   4:....-  ':.----.  +:.-.-.
E:.     N:-.    W:.--    5:.....  !:-.-.--  -:-....-
F:..-.  O:---   X:-..-   6:-....  /:-..-.   _:..--.-
G:--.   P:.--.  Y:-.--   7:--...  (:-.--.   ":.-..-.
H:....  Q:--.-  Z:--..   8:---..  ):-.--.-  $:...-..-
I:..    R:.-.   0:-----  9:----.  &:.-...   @:.--.-.
`

func init() {
	// Convert the rawMorse table into a map of morse key actions.
	r := regexp.MustCompile("([^ ]):([.-]+)")
	for _, m := range r.FindAllStringSubmatch(rawMorse, -1) {
		c := m[1][0]
		keys := []key{}
		for i, dd := range m[2] {
			if i > 0 {
				keys = append(keys, interCharGap...)
			}
			if dd == '.' {
				keys = append(keys, key{1, true, "."})
			} else if dd == '-' {
				keys = append(keys, key{3, true, "-"})
			} else {
				log.Fatalf("found %c in morse for %c", dd, c)
			}
			runeToKeys[rune(c)] = keys
			runeToKeys[unicode.ToLower(rune(c))] = keys
		}
	}
}

// MorseKeys translates an input string into a series of keys.
func MorseKeys(in string) ([]key, error) {
	afterWord := false
	afterChar := false
	result := []key{}
	for _, c := range in {
		if unicode.IsSpace(c) {
			afterWord = true
			continue
		}
		morse, ok := runeToKeys[c]
		if !ok {
			return nil, fmt.Errorf("can't translate %c to morse", c)
		}
		if unicode.IsPunct(c) && afterChar {
			result = append(result, punctGap...)
		} else if afterWord {
			result = append(result, wordGap...)
		} else if afterChar {
			result = append(result, charGap...)
		}
		result = append(result, morse...)
		afterChar = true
		afterWord = false
	}
	return result, nil
}

func main() {
	var ditDuration time.Duration
	flag.DurationVar(&ditDuration, "d", 40*time.Millisecond, "length of dit")
	flag.Parse()
	in := "hello world."
	if len(flag.Args()) > 1 {
		in = strings.Join(flag.Args(), " ")
	}
	keys, err := MorseKeys(in)
	if err != nil {
		log.Fatalf("failed to translate: %s", err)
	}
	for _, k := range keys {
		if k.on {
			if err := note(true); err != nil {
				log.Fatalf("failed to play note: %s", err)
			}
		}
		fmt.Print(k.sym)
		time.Sleep(ditDuration * time.Duration(k.duration))
		if k.on {
			if err := note(false); err != nil {
				log.Fatalf("failed to stop note: %s", err)
			}
		}
	}
	fmt.Println()
}

// Implement sound on ubuntu. Needs permission to access /dev/console.

var consoleFD uintptr

func init() {
	fd, err := syscall.Open("/dev/console", syscall.O_WRONLY, 0)
	if err != nil {
		log.Fatalf("failed to get console device: %s", err)
	}
	consoleFD = uintptr(fd)
}

const KIOCSOUND = 0x4B2F
const clockTickRate = 1193180
const freqHz = 600

// note either starts or stops a note.
func note(on bool) error {
	arg := uintptr(0)
	if on {
		arg = clockTickRate / freqHz
	}
	_, _, errno := syscall.Syscall(syscall.SYS_IOCTL, consoleFD, KIOCSOUND, arg)
	if errno != 0 {
		return errno
	}
	return nil

}
