package config

import (
	"errors"
	"io"
	"fmt"
	"bytes"
	"strings"
	"io/ioutil"
)

var (
	ENONE    = errors.New("Requested value does not exist")
	EBADTYPE = errors.New("Requested type and actual type do not match")
	EBADVAL  = errors.New("Value and type do not match")
)

type varError struct {
	err error
	n   string
	t   VarType
}

func (err *varError) Error() string {
	return fmt.Sprintf("%v: (%q, %v)", err.err, err.n, err.t)
}

type VarType int

const (
	Bool VarType = 1 + iota
	Array
	String
)

func (t VarType) String() string {
	switch t {
	case Bool:
		return "Bool"
	case Array:
		return "Array"
	case String:
		return "String"
	}

	panic("Unknown VarType")
}

type confvar struct {
	Type VarType
	Val  interface{}
}

type Config struct {
	m map[string]confvar
}

func Parse(r io.Reader) (c *Config, err error) {
	c = new(Config)
	c.m = make(map[string]confvar)

	buf, err := ioutil.ReadAll(r)
	if err != nil {
		return
	}

	lines := bytes.Split(buf, []byte{'\n'})

	for _, line := range lines {
		line = bytes.TrimSpace(line)
		if len(line) == 0 {
			continue
		}
		switch line[0] {
		case '#', ';':
			continue
		}

		parts := bytes.SplitN(line, []byte{' '}, 2)
		nam := string(bytes.ToLower(parts[0]))

		if len(parts) == 1 {
			c.m[nam] = confvar{Bool, true}
			continue
		}

		if strings.Contains(string(parts[1]), ",") {
			tmpB := bytes.Split(parts[1], []byte{','})
			for i := range tmpB {
				tmpB[i] = bytes.TrimSpace(tmpB[i])
			}
			tmpS := make([]string, 0, len(tmpB))
			for i := range tmpB {
				tmpS = append(tmpS, string(tmpB[i]))
			}

			c.m[nam] = confvar{Array, tmpS}
			continue
		}

		c.m[nam] = confvar{String, string(bytes.TrimSpace(parts[1]))}
	}

	return
}

func (c *Config) Bool(name string) (bool, error) {
	name = strings.ToLower(name)

	if _, ok := c.m[name]; !ok {
		return false, nil
	}

	if c.m[name].Type != Bool {
		return false, &varError{EBADTYPE, name, Bool}
	}

	v, ok := c.m[name].Val.(bool)
	if !ok {
		return false, &varError{EBADVAL, name, Bool}
	}
	return v, nil
}

func (c *Config) Array(name string) ([]string, error) {
	name = strings.ToLower(name)

	if _, ok := c.m[name]; !ok {
		return nil, &varError{ENONE, name, Array}
	}

	if c.m[name].Type != Array {
		return nil, &varError{EBADTYPE, name, Array}
	}

	v, ok := c.m[name].Val.([]string)
	if !ok {
		return nil, &varError{EBADVAL, name, Array}
	}
	return v, nil
}

func (c *Config) String(name string) (string, error) {
	name = strings.ToLower(name)

	if _, ok := c.m[name]; !ok {
		return "", &varError{ENONE, name, String}
	}

	if c.m[name].Type != String {
		return "", &varError{EBADTYPE, name, String}
	}

	v, ok := c.m[name].Val.(string)
	if !ok {
		return "", &varError{EBADVAL, name, String}
	}

	return v, nil
}
