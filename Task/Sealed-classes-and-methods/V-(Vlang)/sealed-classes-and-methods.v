enum Verify {
	parent
	child
}

struct Parent {
	name string
	age  int
}

struct Child {
	Parent
}

type Family = Parent | Child // sum type

fn (fam &Family) watch_movie(id Verify) {
	if id == .child && fam.age < 15 { println("Sorry, ${fam.name}, you are too young to watch the movie.") }
    else { println("${fam.name} is watching the movie...") }
}

fn main() {
	mut par := Parent{"Donald", 42}
	mut c1, mut c2 := Child{Parent{"Lisa", 18}}, Child{Parent{"Fred", 10}}
    mut fam := []Family{}
    fam << [par, c1, c2]
    for idx, _ in fam {
        if fam[idx] is Child { fam[idx].watch_movie(.child) }
        else { fam[idx].watch_movie(.parent) }
    }
}
