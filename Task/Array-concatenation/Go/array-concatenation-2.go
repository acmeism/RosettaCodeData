package main

import (
  "reflect"
  "fmt"
)

// Generic version
// Easier to make the generic version accept any number of arguments,
// and loop trough them. Otherwise there will be lots of code duplication.
func ArrayConcat(arrays ...interface{}) interface{} {
  if len(arrays) == 0 {
    panic("Need at least one arguemnt")
  }
  var vals = make([]*reflect.SliceValue, len(arrays))
  var arrtype *reflect.SliceType
  var totalsize int
  for i,a := range arrays {
    v := reflect.NewValue(a)
    switch t := v.Type().(type) {
    case *reflect.SliceType:
      if arrtype == nil {
        arrtype = t
      } else if t != arrtype {
        panic("Unequal types")
      }
      vals[i] = v.(*reflect.SliceValue)
      totalsize += vals[i].Len()
    default: panic("not a slice")
    }
  }
  ret := reflect.MakeSlice(arrtype,totalsize,totalsize)
  targ := ret
  for _,v := range vals {
    reflect.Copy(targ, v)
    targ = targ.Slice(v.Len(),targ.Len())
  }
  return ret.Interface()
}

// Type specific version
func ArrayConcatInts(a, b []int) []int {
  ret := make([]int, len(a) + len(b))
  copy(ret, a)
  copy(ret[len(a):], b)
  return ret
}

func main() {
  test1_a, test1_b := []int{1,2,3}, []int{4,5,6}
  test1_c := ArrayConcatInts(test1_a, test1_b)
  fmt.Println(test1_a, " + ", test1_b, " = ", test1_c)

  test2_a, test2_b := []string{"a","b","c"}, []string{"d","e","f"}
  test2_c := ArrayConcat(test2_a, test2_b).([]string)
  fmt.Println(test2_a, " + ", test2_b, " = ", test2_c)
}
