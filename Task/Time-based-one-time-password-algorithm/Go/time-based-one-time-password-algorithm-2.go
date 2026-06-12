package onetime

import (
	"crypto/sha256"
	"fmt"
	"time"

	"github.com/gwwfps/onetime"
)

func Example_simple() {
	// Simple 6-digit HOTP code:
	var secret = []byte("SOME_SECRET")
	var counter uint64 = 123456
	var otp, _ = onetime.Simple(6)
	var code = otp.HOTP(secret, counter)
	fmt.Println(code)
	// Output:
	// 260040
}

func Example_authenticator() {
	// Google authenticator style 8-digit TOTP code:
	var secret = []byte("SOME_SECRET")
	var otp, _ = onetime.Simple(8)
	var code = otp.TOTP(secret)
	fmt.Println(code)
}

func Example_custom() {
	// 9-digit 5-second-step TOTP starting on midnight 2000-01-01 UTC, using SHA-256:
	var secret = []byte("SOME_SECRET")
	const ts = 5 * time.Second
	var t = time.Date(2000, time.January, 1, 0, 0, 0, 0, time.UTC)
	var otp = onetime.OneTimePassword{
		Digit: 9, TimeStep: ts, BaseTime: t, Hash: sha256.New}
	var code = otp.TOTP(secret)
	fmt.Println(code)
}
