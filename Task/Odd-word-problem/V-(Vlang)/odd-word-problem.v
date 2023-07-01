const str = 'what,is,the;meaning,of:life.'

fn main() {
	mut temp, mut new_str := '', ''
	mut switch := true
	for field in str {
		temp += field.ascii_str()
		if field.is_alnum() == false {
			if switch == true {
				new_str += temp
				temp =''			
				switch = false
				continue
			}		
			else {
				new_str += temp.all_before_last(field.ascii_str()).reverse() + field.ascii_str()
				temp =''			
				switch = true
				continue
			}
		}		
	}
	println(new_str)
}
