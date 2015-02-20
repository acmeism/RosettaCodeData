package main

import (
	"fmt"
	"sort"
)

// language-native data description
type Employee struct {
	Name, ID string
	Salary   int
	Dept     string
}

type EmployeeList []*Employee

var data = EmployeeList{
	{"Tyler Bennett", "E10297", 32000, "D101"},
	{"John Rappl", "E21437", 47000, "D050"},
	{"George Woltman", "E00127", 53500, "D101"},
	{"Adam Smith", "E63535", 18000, "D202"},
	{"Claire Buckman", "E39876", 27800, "D202"},
	{"David McClellan", "E04242", 41500, "D101"},
	{"Rich Holcomb", "E01234", 49500, "D202"},
	{"Nathan Adams", "E41298", 21900, "D050"},
	{"Richard Potter", "E43128", 15900, "D101"},
	{"David Motsinger", "E27002", 19250, "D202"},
	{"Tim Sampair", "E03033", 27000, "D101"},
	{"Kim Arlich", "E10001", 57000, "D190"},
	{"Timothy Grove", "E16398", 29900, "D190"},
	// Extra data to demonstrate ties
	{"Tie A", "E16399", 29900, "D190"},
	{"Tie B", "E16400", 29900, "D190"},
	{"No Tie", "E16401", 29899, "D190"},
}

// We only need one type of ordering/grouping for this task so we could directly
// implement sort.Interface on EmployeeList (or a byDeptSalary alias type) with
// the appropriate Less method.
//
// Instead, we'll add a bit here that makes it easier to use arbitrary orderings.
// This is like the "SortKeys" Planet sorting example in the sort package
// documentation, see https://golang.org/pkg/sort

type By func(e1, e2 *Employee) bool
type employeeSorter struct {
	list EmployeeList
	by   func(e1, e2 *Employee) bool
}

func (by By) Sort(list EmployeeList)         { sort.Sort(&employeeSorter{list, by}) }
func (s *employeeSorter) Len() int           { return len(s.list) }
func (s *employeeSorter) Swap(i, j int)      { s.list[i], s.list[j] = s.list[j], s.list[i] }
func (s *employeeSorter) Less(i, j int) bool { return s.by(s.list[i], s.list[j]) }

// For this specific task we could just write the data to an io.Writer
// but in general it's better to return the data in a usable form (for
// example, perhaps other code want's to do something like compare the
// averages of the top N by department).
//
// So we go through the extra effort of returning an []EmployeeList, a
// list of employee lists, one per deparment. The lists are trimmed to
// to the top 'n', which can be larger than n if there are ties for the
// nth salary (callers that don't care about ties could just trim more.)
func (el EmployeeList) TopSalariesByDept(n int) []EmployeeList {
	if n <= 0 || len(el) == 0 {
		return nil
	}
	deptSalary := func(e1, e2 *Employee) bool {
		if e1.Dept != e2.Dept {
			return e1.Dept < e2.Dept
		}
		if e1.Salary != e2.Salary {
			return e1.Salary > e2.Salary
		}
		// Always have some unique field as the last one in a sort list
		return e1.ID < e2.ID
	}

	// We could just sort the data in place for this task. But
	// perhaps messing with the order is undesirable or there is
	// other concurrent access. So we'll make a copy and sort that.
	// It's just pointers so the amount to copy is relatively small.
	sorted := make(EmployeeList, len(el))
	copy(sorted, el)
	By(deptSalary).Sort(sorted)

	perDept := []EmployeeList{}
	var lastDept string
	var lastSalary int
	for _, e := range sorted {
		if e.Dept != lastDept || len(perDept) == 0 {
			lastDept = e.Dept
			perDept = append(perDept, EmployeeList{e})
		} else {
			i := len(perDept) - 1
			if len(perDept[i]) >= n && e.Salary != lastSalary {
				continue
			}
			perDept[i] = append(perDept[i], e)
			lastSalary = e.Salary
		}
	}
	return perDept
}

func main() {
	const n = 3
	top := data.TopSalariesByDept(n)
	if len(top) == 0 {
		fmt.Println("Nothing to show.")
		return
	}
	fmt.Printf("Top %d salaries per department\n", n)
	for _, list := range top {
		fmt.Println(list[0].Dept)
		for _, e := range list {
			fmt.Printf("    %s %16s %7d\n", e.ID, e.Name, e.Salary)
		}
	}
}
