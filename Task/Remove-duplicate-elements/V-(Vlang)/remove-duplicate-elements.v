const list = 'a,1,a,b,b,c,d,e,d,0,f,f,5,f,g,h,1,3,3'

fn main() {
	println(unique(list))
}

fn unique(list string) []string {
    mut new_list := []string{}
    for word in list.split(',') {
        if new_list.any(it == word.str()) == false {
            new_list << word
        }
    }
    new_list.sort()
    return new_list
}
