package main

import (
    gc "github.com/rthornton128/goncurses"
    "log"
    "math/rand"
    "time"
)

// Time between row updates in microseconds.
// Controls the speed of the digital rain effect.
const rowDelay = 40000

func main() {
    start := time.Now()
    rand.Seed(time.Now().UnixNano())

    // Characters to randomly appear in the rain sequence.
    chars := []byte("0123456789")
    totalChars := len(chars)

    // Set up ncurses screen and colors.
    stdscr, err := gc.Init()
    if err != nil {
        log.Fatal("init", err)
    }
    defer gc.End()

    gc.Echo(false)
    gc.Cursor(0)

    if !gc.HasColors() {
        log.Fatal("Program requires a colour capable terminal")
    }

    if err := gc.StartColor(); err != nil {
        log.Fatal(err)
    }

    if err := gc.InitPair(1, gc.C_GREEN, gc.C_BLACK); err != nil {
        log.Fatal("InitPair failed: ", err)
    }
    stdscr.ColorOn(1)
    maxY, maxX := stdscr.MaxYX()

    /* Create slices of columns based on screen width. */

    // Slice containing the current row of each column.
    columnsRow := make([]int, maxX)

    // Slice containing the active status of each column.
    // A column draws characters on a row when active.
    columnsActive := make([]int, maxX)

    // Set top row as current row for all columns.
    for i := 0; i < maxX; i++ {
        columnsRow[i] = -1
        columnsActive[i] = 0
    }

    for {
        for i := 0; i < maxX; i++ {
            if columnsRow[i] == -1 {
                // If a column is at the top row, pick a
                // random starting row and active status.
                columnsRow[i] = rand.Intn(maxY + 1)
                columnsActive[i] = rand.Intn(2)
            }
        }

        // Loop through columns and draw characters on rows.
        for i := 0; i < maxX; i++ {
            if columnsActive[i] == 1 {
                // Draw a random character at this column's current row.
                charIndex := rand.Intn(totalChars)
                stdscr.MovePrintf(columnsRow[i], i, "%c", chars[charIndex])
            } else {
                // Draw an empty character if the column is inactive.
                stdscr.MovePrintf(columnsRow[i], i, "%c", ' ')
            }

            columnsRow[i]++

            // When a column reaches the bottom row, reset to top.
            if columnsRow[i] >= maxY {
                columnsRow[i] = -1
            }

            // Randomly alternate the column's active status.
            if rand.Intn(1001) == 0 {
                if columnsActive[i] == 0 {
                    columnsActive[i] = 1
                } else {
                    columnsActive[i] = 0
                }
            }
        }
        time.Sleep(rowDelay * time.Microsecond)
        stdscr.Refresh()
        elapsed := time.Since(start)
        // Stop after 1 minute.
        if elapsed.Minutes() >= 1 {
            break
        }
    }
}
