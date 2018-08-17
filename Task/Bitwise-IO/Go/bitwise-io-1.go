// Package bit provides bit-wise IO to an io.Writer and from an io.Reader.
package bit

import (
	"bufio"
	"errors"
	"io"
)

// Order specifies the bit ordering within a byte stream.
type Order int

const (
	// LSB is for Least Significant Bits first
	LSB Order = iota
	// MSB is for Most  Significant Bits first
	MSB
)

// ==== Writing / Encoding ====

type writer interface {
	io.ByteWriter
	Flush() error
}

// Writer implements bit-wise writing to an io.Writer.
type Writer struct {
	w     writer
	order Order
	write func(uint32, uint) error // writeLSB or writeMSB
	bits  uint32
	nBits uint
	err   error
}

// writeLSB writes `width` bits of `c` in LSB order.
func (w *Writer) writeLSB(c uint32, width uint) error {
	w.bits |= c << w.nBits
	w.nBits += width
	for w.nBits >= 8 {
		if err := w.w.WriteByte(uint8(w.bits)); err != nil {
			return err
		}
		w.bits >>= 8
		w.nBits -= 8
	}
	return nil
}

// writeMSB writes `width` bits of `c` in MSB order.
func (w *Writer) writeMSB(c uint32, width uint) error {
	w.bits |= c << (32 - width - w.nBits)
	w.nBits += width
	for w.nBits >= 8 {
		if err := w.w.WriteByte(uint8(w.bits >> 24)); err != nil {
			return err
		}
		w.bits <<= 8
		w.nBits -= 8
	}
	return nil
}

// WriteBits writes up to 16 bits of `c` to the underlying writer.
// Even for MSB ordering the bits are taken from the lower bits of `c`.
// (e.g. WriteBits(0x0f,4) writes four 1 bits).
func (w *Writer) WriteBits(c uint16, width uint) error {
	if w.err == nil {
		w.err = w.write(uint32(c), width)
	}
	return w.err
}

var errClosed = errors.New("bit reader/writer is closed")

// Close closes the writer, flushing any pending output.
// It does not close the underlying writer.
func (w *Writer) Close() error {
	if w.err != nil {
		if w.err == errClosed {
			return nil
		}
		return w.err
	}
	// Write the final bits (zero padded).
	if w.nBits > 0 {
		if w.order == MSB {
			w.bits >>= 24
		}
		if w.err = w.w.WriteByte(uint8(w.bits)); w.err != nil {
			return w.err
		}
	}
	w.err = w.w.Flush()
	if w.err != nil {
		return w.err
	}

	// Make any future calls to Write return errClosed.
	w.err = errClosed
	return nil
}

// NewWriter returns a new bit Writer that writes completed bytes to `w`.
func NewWriter(w io.Writer, order Order) *Writer {
	bw := &Writer{order: order}
	switch order {
	case LSB:
		bw.write = bw.writeLSB
	case MSB:
		bw.write = bw.writeMSB
	default:
		bw.err = errors.New("bit writer: unknown order")
		return bw
	}
	if byteWriter, ok := w.(writer); ok {
		bw.w = byteWriter
	} else {
		bw.w = bufio.NewWriter(w)
	}
	return bw
}

// ==== Reading / Decoding ====

// Reader implements bit-wise reading from an io.Reader.
type Reader struct {
	r     io.ByteReader
	bits  uint32
	nBits uint
	read  func(width uint) (uint16, error) // readLSB or readMSB
	err   error
}

func (r *Reader) readLSB(width uint) (uint16, error) {
	for r.nBits < width {
		x, err := r.r.ReadByte()
		if err != nil {
			return 0, err
		}
		r.bits |= uint32(x) << r.nBits
		r.nBits += 8
	}
	bits := uint16(r.bits & (1<<width - 1))
	r.bits >>= width
	r.nBits -= width
	return bits, nil
}

func (r *Reader) readMSB(width uint) (uint16, error) {
	for r.nBits < width {
		x, err := r.r.ReadByte()
		if err != nil {
			return 0, err
		}
		r.bits |= uint32(x) << (24 - r.nBits)
		r.nBits += 8
	}
	bits := uint16(r.bits >> (32 - width))
	r.bits <<= width
	r.nBits -= width
	return bits, nil
}

// ReadBits reads up to 16 bits from the underlying reader.
func (r *Reader) ReadBits(width uint) (uint16, error) {
	var bits uint16
	if r.err == nil {
		bits, r.err = r.read(width)
	}
	return bits, r.err
}

// Close closes the reader.
// It does not close the underlying reader.
func (r *Reader) Close() error {
	if r.err != nil && r.err != errClosed {
		return r.err
	}
	r.err = errClosed
	return nil
}

// NewReader returns a new bit Reader that reads bytes from `r`.
func NewReader(r io.Reader, order Order) *Reader {
	br := new(Reader)
	switch order {
	case LSB:
		br.read = br.readLSB
	case MSB:
		br.read = br.readMSB
	default:
		br.err = errors.New("bit writer: unknown order")
		return br
	}
	if byteReader, ok := r.(io.ByteReader); ok {
		br.r = byteReader
	} else {
		br.r = bufio.NewReader(r)
	}
	return br
}
