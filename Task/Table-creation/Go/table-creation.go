package main

import (
    "encoding/binary"
    "encoding/json"
    "fmt"
    "github.com/boltdb/bolt"
    "log"
)

type StockTrans struct {
    Id       int // this will be auto-incremented by db
    Date     string
    Trans    string
    Symbol   string
    Quantity int
    Price    float32
    Settled  bool
}

// save stock transaction to bucket in db
func (st *StockTrans) save(db *bolt.DB, bucket string) error {
    err := db.Update(func(tx *bolt.Tx) error {
        b := tx.Bucket([]byte(bucket))
        id, _ := b.NextSequence()
        st.Id = int(id)
        encoded, err := json.Marshal(st)
        if err != nil {
            return err
        }
        return b.Put(itob(st.Id), encoded)
    })
    return err
}

// itob returns an 8-byte big endian representation of i.
func itob(i int) []byte {
    b := make([]byte, 8)
    binary.BigEndian.PutUint64(b, uint64(i))
    return b
}

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

func main() {
    // create database
    db, err := bolt.Open("store.db", 0600, nil)
    check(err)
    defer db.Close()

    // create bucket
    err = db.Update(func(tx *bolt.Tx) error {
        _, err := tx.CreateBucketIfNotExists([]byte("stocks"))
        return err
    })
    check(err)

    transactions := []*StockTrans{
        {0, "2006-01-05", "BUY", "RHAT", 100, 35.14, true},
        {0, "2006-03-28", "BUY", "IBM", 1000, 45, true},
        {0, "2006-04-06", "SELL", "IBM", 500, 53, true},
        {0, "2006-04-05", "BUY", "MSOFT", 1000, 72, false},
    }

    // save transactions to bucket
    for _, trans := range transactions {
        err := trans.save(db, "stocks")
        check(err)
    }

    // print out contents of bucket
    fmt.Println("Id     Date    Trans  Sym    Qty  Price  Settled")
    fmt.Println("------------------------------------------------")
    db.View(func(tx *bolt.Tx) error {
        b := tx.Bucket([]byte("stocks"))
        b.ForEach(func(k, v []byte) error {
            st := new(StockTrans)
            err := json.Unmarshal(v, st)
            check(err)
            fmt.Printf("%d  %s  %-4s  %-5s  %4d  %2.2f  %t\n",
                st.Id, st.Date, st.Trans, st.Symbol, st.Quantity, st.Price, st.Settled)
            return nil
        })
        return nil
    })
}
