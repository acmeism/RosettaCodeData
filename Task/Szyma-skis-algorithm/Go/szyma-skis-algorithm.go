package main

import (
	"fmt"
	"math/rand"
	"runtime"
	"sync"
	"time"
)

// Define constants for state representation
const (
	OUTSIDE             = 0
	WAITING_ROOM        = 1
	DOORWAY             = 3
	WAITING_FOR_OTHERS  = 2
	IN_CRITICAL_SECTION = 4
)

func runSzymanski(id int, allSzy []int, flags *sync.Map, dictCond *sync.Cond, criticalValueMutex *sync.Mutex, criticalValue *int) {
	others := make([]int, 0)
	for _, t := range allSzy {
		if t != id {
			others = append(others, t)
		}
	}

	// Standing outside waiting room
	flags.Store(id, WAITING_ROOM)

	// Wait until no other process is in or passing through the doorway.
	for any(others, func(t int) bool {
		val, ok := flags.Load(t)
		return ok && val.(int) >= DOORWAY
	}) {
		runtime.Gosched() // Yield CPU to other goroutines
	}

	// Standing in doorway
	flags.Store(id, DOORWAY)

	// Check if other processes are still waiting
	if any(others, func(t int) bool {
		val, ok := flags.Load(t)
		return ok && ok && val.(int) == WAITING_ROOM
	}) {
		// Waiting for other processes to enter
		flags.Store(id, WAITING_FOR_OTHERS)
		dictCond.Broadcast()

		// Wait for other processes to close the door
		for !any(others, func(t int) bool {
			val, ok := flags.Load(t)
			return ok && val.(int) == IN_CRITICAL_SECTION
		}) {
			dictCond.L.Lock()
			dictCond.Wait()
			dictCond.L.Unlock()
			runtime.Gosched() // Yield CPU
		}
	}

	// The door is closed
	flags.Store(id, IN_CRITICAL_SECTION)
	dictCond.Broadcast()

	// Wait for lower numbered processes
	for _, t := range others {
		if t >= id {
			continue
		}
		for {
			val, ok := flags.Load(t)
			if !ok || val.(int) <= WAITING_ROOM {
				break
			}
			runtime.Gosched()
		}
	}

	// Critical section
	criticalValueMutex.Lock()
	*criticalValue += id * 3
	*criticalValue /= 2
	fmt.Printf("Thread %d changed the critical value to %d.\n", id, *criticalValue)
	criticalValueMutex.Unlock()

	// Exit protocol
	for _, t := range others {
		if t <= id {
			continue
		}

		for {
			val, ok := flags.Load(t)
			if !ok || (val.(int) == OUTSIDE || val.(int) == WAITING_ROOM || val.(int) == IN_CRITICAL_SECTION) {
				break
			}
			runtime.Gosched()
		}
	}

	// Leave
	flags.Store(id, OUTSIDE)
	dictCond.Broadcast()
}

func testSzymanski(n int) {
	allSzy := make([]int, n)
	for i := 0; i < n; i++ {
		allSzy[i] = i + 1
	}

	var flags sync.Map
	var criticalValue int = 1
	var criticalValueMutex sync.Mutex
	dictMutex := &sync.Mutex{}
	dictCond := sync.NewCond(dictMutex)

	var wg sync.WaitGroup
	for _, i := range allSzy {
		wg.Add(1)
		go func(id int) {
			defer wg.Done()
			runSzymanski(id, allSzy, &flags, dictCond, &criticalValueMutex, &criticalValue)
		}(i)
	}

	wg.Wait()
}

func main() {
	rand.Seed(time.Now().UnixNano())
	testSzymanski(20)
}

func any(vs []int, f func(int) bool) bool {
	for _, v := range vs {
		if f(v) {
			return true
		}
	}
	return false
}
