fn main() {
	list := ('ABCD CABD ACDB DACB BCDA ACBD ADCB CDAB DABC BCAD CADB
	CDBA CBAD ABDC ADBC BDCA DCBA BACD BADC BDAC CBDA DBCA DCAB')
	elem := ['A', 'B', 'C', 'D']
	if find_missed_pmt_1(list, elem) !='' {println('${find_missed_pmt_1(list, elem)} is missing')}
	else {println('Warning: nothing found')}
	if find_missed_pmt_2(list, elem) !='' {println('${find_missed_pmt_2(list, elem)} is missing')}
	else {println('Warning: nothing found')}
	if find_missed_pmt_3(list, elem) !='' {println('${find_missed_pmt_3(list, elem)} is missing')}
	else {println('Warning: nothing found')}
}

fn find_missed_pmt_1(list string, elem []string) string {
	mut result := ''
	for avals in elem {
		for bvals in elem {
			for cvals in elem {
				for dvals in elem {
					result = avals + bvals + cvals + dvals
					if avals != bvals
					&& avals != cvals
					&& avals != dvals
					&& bvals != cvals
					&& bvals != dvals
					&& cvals != dvals {
						if list.replace_each(['\n','','\t','']).split(' ').any(it == result) == false {return result}
					}
				}
			}
		}
	}
	return result
}

fn find_missed_pmt_2(list string, elem []string) string {
	list_arr := list.replace_each(['\n','','\t','']).split(' ')	
	mut es := []u8{len: elem.len}
	mut aa := map[u8]int{}
	mut result :=''
	for idx, _ in es {
		aa = map[u8]int{}
		for vals in list_arr {
			aa[vals[idx]]++
		}
		for chr, count in aa {
			if count & 1 == 1 {
				result += chr.ascii_str()
				break
			}
		}
	}
	return result
}

fn find_missed_pmt_3(list string, elem []string) string {
	list_arr := list.replace_each(['\n','','\t','']).split(' ')
	mut miss_1_arr, mut miss_2_arr, mut miss_3_arr, mut miss_4_arr := []u8{}, []u8{}, []u8{}, []u8{}
	mut res1, mut res2, mut res3, mut res4 := '', '', '', ''
	
	for group in list_arr {
		for chr in group[0].ascii_str() {miss_1_arr << chr}
		for chr in group[1].ascii_str() {miss_2_arr << chr}
		for chr in group[2].ascii_str()	{miss_3_arr << chr}
		for chr in group[3].ascii_str()	{miss_4_arr << chr}
	}
	for chr in elem {
		if miss_1_arr.bytestr().count(chr) < 6 {res1 = chr}
		if miss_2_arr.bytestr().count(chr) < 6 {res2 = chr}
		if miss_3_arr.bytestr().count(chr) < 6 {res3 = chr}
		if miss_4_arr.bytestr().count(chr) < 6 {res4 = chr}
	}
	return res1 + res2 + res3 + res4
}
