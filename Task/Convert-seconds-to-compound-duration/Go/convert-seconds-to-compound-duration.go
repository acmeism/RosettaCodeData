package main

import "fmt"

func main(){
	fmt.Println(TimeStr(7259))
	fmt.Println(TimeStr(86400))
	fmt.Println(TimeStr(6000000))
}

func TimeStr(sec int)(res string){
	wks, sec := sec / 604800,sec % 604800
	ds, sec := sec / 86400, sec % 86400
	hrs, sec := sec / 3600, sec % 3600
	mins, sec := sec / 60, sec % 60
	CommaRequired := false
	if wks != 0 {
		res += fmt.Sprintf("%d wk",wks)
		CommaRequired = true
	}
	if ds != 0 {
		if CommaRequired {
			res += ", "
		}
		res += fmt.Sprintf("%d d",ds)
		CommaRequired = true
	}
	if hrs != 0 {
		if CommaRequired {
			res += ", "
		}
		res += fmt.Sprintf("%d hr",hrs)
		CommaRequired = true
	}
	if mins != 0 {
		if CommaRequired {
			res += ", "
		}
		res += fmt.Sprintf("%d min",mins)
		CommaRequired = true
	}
	if sec != 0 {
		if CommaRequired {
			res += ", "
		}
		res += fmt.Sprintf("%d sec",sec)
	}
	return
}
