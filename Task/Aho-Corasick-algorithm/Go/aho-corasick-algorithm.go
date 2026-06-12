package main

import (
	"bufio"
	"fmt"
	"os"
)

type Node struct {
	son  [26]int
	ans  int
	fail int
	du   int
	idx  int
}

type ACAutomaton struct {
	tr        []Node
	tot       int
	finalAns  []int
	pidx      int
}

func NewACAutomaton(maxNodes int) *ACAutomaton {
	ac := &ACAutomaton{
		tr:       make([]Node, maxNodes),
		tot:      0,
		finalAns: []int{},
		pidx:     0,
	}
	ac.tr[0] = Node{}
	return ac
}

func (ac *ACAutomaton) Init() {
	ac.tr = make([]Node, len(ac.tr))
	ac.tr[0] = Node{}
	ac.tot = 0
	ac.pidx = 0
	ac.finalAns = []int{}
}

func (ac *ACAutomaton) Insert(pattern string) int {
	u := 0
	for _, char := range pattern {
		charCode := int(char - 'a')
		if ac.tr[u].son[charCode] == 0 {
			ac.tot++
			ac.tr[u].son[charCode] = ac.tot
		}
		u = ac.tr[u].son[charCode]
	}
	if ac.tr[u].idx == 0 {
		ac.pidx++
		ac.tr[u].idx = ac.pidx
	}
	return ac.tr[u].idx
}

func (ac *ACAutomaton) Build() {
	q := []int{}
	for i := 0; i < 26; i++ {
		if ac.tr[0].son[i] != 0 {
			q = append(q, ac.tr[0].son[i])
		}
	}
	
	for len(q) > 0 {
		u := q[0]
		q = q[1:]
		
		for i := 0; i < 26; i++ {
			sonNodeIdx := ac.tr[u].son[i]
			failNodeIdx := ac.tr[u].fail
			
			if sonNodeIdx != 0 {
				ac.tr[sonNodeIdx].fail = ac.tr[failNodeIdx].son[i]
				ac.tr[ac.tr[sonNodeIdx].fail].du++
				q = append(q, sonNodeIdx)
			} else {
				ac.tr[u].son[i] = ac.tr[failNodeIdx].son[i]
			}
		}
	}
}

func (ac *ACAutomaton) Query(text string) {
	u := 0
	for _, char := range text {
		charCode := int(char - 'a')
		u = ac.tr[u].son[charCode]
		ac.tr[u].ans++
	}
}

func (ac *ACAutomaton) CalculateFinalAnswers() {
	ac.finalAns = make([]int, ac.pidx+1)
	q := []int{}
	
	for i := 0; i <= ac.tot; i++ {
		if ac.tr[i].du == 0 {
			q = append(q, i)
		}
	}
	
	for len(q) > 0 {
		u := q[0]
		q = q[1:]
		
		nodeIdx := ac.tr[u].idx
		if nodeIdx != 0 {
			ac.finalAns[nodeIdx] = ac.tr[u].ans
		}
		
		v := ac.tr[u].fail
		ac.tr[v].ans += ac.tr[u].ans
		ac.tr[v].du--
		
		if ac.tr[v].du == 0 {
			q = append(q, v)
		}
	}
}

func fastInput() string {
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Scan()
	return scanner.Text()
}

func main() {
	MAX_NODES := 200000 + 6
	n := 5
	
	ac := NewACAutomaton(MAX_NODES)
	patternEndNodeIds := make([]int, n+1)
	
	myInput := []string{"a", "bb", "aa", "abaa", "abaaa"}
	text := "abaaabaa"
	
	for i := 1; i <= n; i++ {
		pattern := myInput[i-1]
		patternEndNodeIds[i] = ac.Insert(pattern)
	}
	
	ac.Build()
	ac.Query(text)
	ac.CalculateFinalAnswers()
	
	for i := 1; i <= n; i++ {
		uniqueID := patternEndNodeIds[i]
		fmt.Println(ac.finalAns[uniqueID])
	}
}
