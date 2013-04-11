package digit

import (
    "errors"
    "strconv"
)

func Sum(n string, base int) (int64, error) {
    if base < 2 || base > 36 {
        return 0, errors.New("base must be from 2 to 36")
    }
    i, err := strconv.ParseInt(n, base, 64)
    if err != nil {
        return 0, err
    }
    if i < 0 {
        return 0, errors.New("number must be non-negative")
    }
    b64 := int64(base)
    var sum int64
    for i > 0 {
        sum += i % b64
        i /= b64
    }
    return sum, nil
}
