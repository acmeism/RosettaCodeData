const door_number = 100

fn main(){
    mut doors := []bool{ len: door_number, init: false } //true open false closed

    mut door_nbr := 1
    mut increment := 0

    for current in 1..( door_number + 1) {
        if current == door_nbr {
            doors[current - 1] = true
            increment++
            door_nbr += 2 * increment + 1
        }
    }
    doors.map( fn( it bool) bool {  // graphically represent opened doors
        print( if it {( 'O')} else {('=')} )
        return it
    })
    println('')
}
