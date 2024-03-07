fn check_isbn13(isbn13 string) bool {
    // remove any hyphens or spaces
    isbn := isbn13.replace('-','').replace(' ','')
    // check length == 13
    le := isbn.len
    if le != 13 {
        return false
    }
    // check only contains digits and calculate weighted sum
    mut sum := 0
    for i, c in isbn.split('') {
        if c.int() < '0'.int() || c.int() > '9'.int() {
            return false
        }
        if i%2 == 0 {
            sum += c.int() - '0'.int()
        } else {
            sum += 3 * (c.int() - '0'.int())
        }
    }
    return sum%10 == 0
}

fn main() {
    isbns := ["978-0596528126", "978-0596528120", "978-1788399081", "978-1788399083"]
    for isbn in isbns {
        mut res := "bad"
        if check_isbn13(isbn) {
            res = "good"
        }
        println("$isbn: $res")
    }
}
