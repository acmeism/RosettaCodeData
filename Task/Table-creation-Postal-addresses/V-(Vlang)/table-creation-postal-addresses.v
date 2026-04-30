import os

const record_length = 127
const input = [
        new_address("FSF Inc.", "51 Franklin Street", "Boston", "MA", "02110-1301", 1),
        new_address("The White House", "The Oval Office, 1600 Pennsylvania Avenue NW",
		"Washington", "DC", "20500", 2),
    ]

struct Address {
    mut:
    id       i64
    name     string
    street   string
    city     string
    state    string
    zip_code string
}

fn (a Address) to_string() string {
    return "Id       : $a.id\n" +
        "Name     : $a.name\n" +
        "Street   : $a.street\n" +
        "City     : $a.city\n" +
        "State    : $a.state\n" +
        "Zip Code : $a.zip_code\n"
}

// write the record at the correct position in the file
fn (mut a Address) write_record(file_path string) ! {
    mut f := os.open_file(file_path, "r+") or {
        // if file doesn"t exist, create it
        os.create(file_path) or { return err }
        os.open_file(file_path, "r+") or { return err }
    }
    defer { f.close() }
    // compose fixed-length text block
    text := pad_to_fixed_length(a.name, 30) +
        pad_to_fixed_length(a.street, 50) +
        pad_to_fixed_length(a.city, 25) +
        pad_to_fixed_length(a.state, 2) +
        pad_to_fixed_length(a.zip_code, 10)
    // prepare bytes: 8 bytes for id (i64), then UTF-8 bytes of text padded to record_length - 8
    mut buf := []u8{len: record_length, init: 0}
    // write id as 8 bytes little endian
    for i in 0 .. 8 { buf[i] = u8((a.id >> (i * 8)) & 0xff) }
    // write UTF-8 text bytes starting at offset 8
    text_bytes := text.bytes()
    for i, b in text_bytes {
        if 8 + i < record_length { buf[8 + i] = b }
    }
    // seek to position (id -1) * record_length
    pos := (a.id - 1) * i64(record_length)
    f.seek(pos, .start) or { return err }
    // write buffer
    written := f.write(buf) or { return err }
    if written != record_length { return error("Failed to write full record") }
}

fn new_address(name string, street string, city string, state string, zip_code string, id i64) Address {
    return Address{
        id: id
        name: name
        street: street
        city: city
        state: state
        zip_code: zip_code
    }
}

fn pad_to_fixed_length(s string, len int) string {
    if s.len > len { return s[..len] }
    return s + " ".repeat(len - s.len)
}

// read a record by id from file
fn read_record(file_path string, id i64) !Address {
    mut f := os.open_file(file_path, "r") or { return err }
    defer { f.close() }
    pos := (id - 1) * i64(record_length)
    f.seek(pos, .start) or { return err }
    mut buf := []u8{len: record_length}
    n := f.read(mut buf) or { return err }
    if n != record_length { return error("Could not read full record") }
    // read id from first 8 bytes little endian
    mut read_id := u64(0)
    for i in 0 .. 8 {
 		read_id |= u64(buf[i]) << (i * 8)
    }
    if read_id != id { return error("Database is corrupt: id mismatch") }
    // extract text from bytes 8 to end
    text_bytes := buf[8..].clone()
    text := text_bytes.bytestr().trim_space()
    // extract fields based on fixed lengths
    name := text[0..30].trim_space()
    street := text[30..80].trim_space()
    city := text[80..105].trim_space()
    state := text[105..107]
    zip_code := text[107..].trim_space()
    return new_address(name, street, city, state, zip_code, id)
}

fn main() {
    file_path := "addresses.dat"
    mut addresses := input.clone()
    // write records
    for mut a in addresses {
        a.write_record(file_path) or {
            eprintln("Failed to write record: $err")
            return
        }
    }
    // read and print in reverse order
    for i := addresses.len; i > 0; i-- {
        rec := read_record(file_path, i) or {
            eprintln("Failed to read record: $err")
            return
        }
        println(rec.to_string())
    }
}
