package box

import "sync/atomic"

var sn uint32

type box struct {
    Contents string
    secret uint32
}

func New() (b *box) {
    b = &box{secret: atomic.AddUint32(&sn, 1)}
    switch sn {
    case 1:
        b.Contents = "rabbit"
    case 2:
        b.Contents = "rock"
    }
    return
}

func (b *box) TellSecret() uint32 {
    return b.secret
}

func Count() uint32 {
    return atomic.LoadUint32(&sn)
}
