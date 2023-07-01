string middlethree(int i) {
	i = abs(i);
	int length = sizeof((string)i);
	
	if(length >= 3) {
		if(length % 2 == 1) {
			int middle = (int)floor(length / 2) - 1;
			return(((string)i)[middle..middle+2]);
		}
		else {
			return "The value must contain an odd amount of digits...";
		}
	}
	else {
			return "The value must contain at least three digits...";
	}
}

int main() {
	array(int) numbers = ({123, 12345, 1234567, 987654321, 10001, -10001, -123, -100, 100, -12345, 1, 2, -1, -10, 2002, -2002, 0});

	foreach(numbers, int nums) {
		write((string)nums + " : " + middlethree(nums) + "\n");
	}
	return 0;
}
