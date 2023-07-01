package main

import (
	"errors"
	"fmt"
	"log"
	"math/rand"
	"time"

	termbox "github.com/nsf/termbox-go"
)

func main() {
	rand.Seed(time.Now().UnixNano())
	score, err := playSnake()
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println("Final score:", score)
}

type snake struct {
	body          []position // tail to head positions of the snake
	heading       direction
	width, height int
	cells         []termbox.Cell
}

type position struct {
	X int
	Y int
}

type direction int

const (
	North direction = iota
	East
	South
	West
)

func (p position) next(d direction) position {
	switch d {
	case North:
		p.Y--
	case East:
		p.X++
	case South:
		p.Y++
	case West:
		p.X--
	}
	return p
}

func playSnake() (int, error) {
	err := termbox.Init()
	if err != nil {
		return 0, err
	}
	defer termbox.Close()

	termbox.Clear(fg, bg)
	termbox.HideCursor()
	s := &snake{
		// It would be more efficient to use a circular
		// buffer instead of a plain slice for s.body.
		body:  make([]position, 0, 32),
		cells: termbox.CellBuffer(),
	}
	s.width, s.height = termbox.Size()
	s.drawBorder()
	s.startSnake()
	s.placeFood()
	s.flush()

	moveCh, errCh := s.startEventLoop()
	const delay = 125 * time.Millisecond
	for t := time.NewTimer(delay); ; t.Reset(delay) {
		var move direction
		select {
		case err = <-errCh:
			return len(s.body), err
		case move = <-moveCh:
			if !t.Stop() {
				<-t.C // handles race between moveCh and t.C
			}
		case <-t.C:
			move = s.heading
		}
		if s.doMove(move) {
			time.Sleep(1 * time.Second)
			break
		}
	}

	return len(s.body), err
}

func (s *snake) startEventLoop() (<-chan direction, <-chan error) {
	moveCh := make(chan direction)
	errCh := make(chan error, 1)
	go func() {
		defer close(errCh)
		for {
			switch ev := termbox.PollEvent(); ev.Type {
			case termbox.EventKey:
				switch ev.Ch { // WSAD and HJKL movement
				case 'w', 'W', 'k', 'K':
					moveCh <- North
				case 'a', 'A', 'h', 'H':
					moveCh <- West
				case 's', 'S', 'j', 'J':
					moveCh <- South
				case 'd', 'D', 'l', 'L':
					moveCh <- East
				case 0:
					switch ev.Key { // Cursor key movement
					case termbox.KeyArrowUp:
						moveCh <- North
					case termbox.KeyArrowDown:
						moveCh <- South
					case termbox.KeyArrowLeft:
						moveCh <- West
					case termbox.KeyArrowRight:
						moveCh <- East
					case termbox.KeyEsc: // Quit
						return
					}
				}
			case termbox.EventResize:
				// TODO
				errCh <- errors.New("terminal resizing unsupported")
				return
			case termbox.EventError:
				errCh <- ev.Err
				return
			case termbox.EventInterrupt:
				return
			}
		}
	}()
	return moveCh, errCh
}

func (s *snake) flush() {
	termbox.Flush()
	s.cells = termbox.CellBuffer()
}

func (s *snake) getCellRune(p position) rune {
	i := p.Y*s.width + p.X
	return s.cells[i].Ch
}
func (s *snake) setCell(p position, c termbox.Cell) {
	i := p.Y*s.width + p.X
	s.cells[i] = c
}

func (s *snake) drawBorder() {
	for x := 0; x < s.width; x++ {
		s.setCell(position{x, 0}, border)
		s.setCell(position{x, s.height - 1}, border)
	}
	for y := 0; y < s.height-1; y++ {
		s.setCell(position{0, y}, border)
		s.setCell(position{s.width - 1, y}, border)
	}
}

func (s *snake) placeFood() {
	for {
		// a random empty cell
		x := rand.Intn(s.width-2) + 1
		y := rand.Intn(s.height-2) + 1
		foodp := position{x, y}
		r := s.getCellRune(foodp)
		if r != ' ' {
			continue
		}
		s.setCell(foodp, food)
		return
	}
}

func (s *snake) startSnake() {
	// a random cell somewhat near the center
	x := rand.Intn(s.width/2) + s.width/4
	y := rand.Intn(s.height/2) + s.height/4
	head := position{x, y}
	s.setCell(head, snakeHead)
	s.body = append(s.body[:0], head)
	s.heading = direction(rand.Intn(4))
}

func (s *snake) doMove(move direction) bool {
	head := s.body[len(s.body)-1]
	s.setCell(head, snakeBody)
	head = head.next(move)
	s.heading = move
	s.body = append(s.body, head)
	r := s.getCellRune(head)
	s.setCell(head, snakeHead)
	gameOver := false
	switch r {
	case food.Ch:
		s.placeFood()
	case border.Ch, snakeBody.Ch:
		gameOver = true
		fallthrough
	case empty.Ch:
		s.setCell(s.body[0], empty)
		s.body = s.body[1:]
	default:
		panic(r)
	}
	s.flush()
	return gameOver
}

const (
	fg = termbox.ColorWhite
	bg = termbox.ColorBlack
)

// Symbols to use.
// Could use Unicode instead of simple ASCII.
var (
	empty     = termbox.Cell{Ch: ' ', Bg: bg, Fg: fg}
	border    = termbox.Cell{Ch: '+', Bg: bg, Fg: termbox.ColorBlue}
	snakeBody = termbox.Cell{Ch: '#', Bg: bg, Fg: termbox.ColorGreen}
	snakeHead = termbox.Cell{Ch: 'O', Bg: bg, Fg: termbox.ColorYellow | termbox.AttrBold}
	food      = termbox.Cell{Ch: '@', Bg: bg, Fg: termbox.ColorRed}
)
