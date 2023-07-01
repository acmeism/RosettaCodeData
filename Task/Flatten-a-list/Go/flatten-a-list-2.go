func flatten(s []interface{}) (r []interface{}) {
    for _, e := range s {
        if i, ok := e.([]interface{}); ok {
            r = append(r, flatten(i)...)
        } else {
            r = append(r, e)
        }
    }
    return
}
