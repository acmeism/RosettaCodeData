array kronecker(array matrix1, array matrix2) {
	array final_list = ({});
	array sub_list = ({});

	int count = sizeof(matrix2);

	foreach(matrix1, array elem1) {
		int counter = 0;
		int check = 0;
		while (check < count) {
			foreach(elem1, int num1) {
				foreach(matrix2[counter], int num2) {
					sub_list = Array.push(sub_list, num1 * num2);
				}
			}
		counter += 1;
		final_list = Array.push(final_list, sub_list);
		sub_list = ({});
		check += 1;
		}
	}	

	return final_list;
}

int main() {
	//Sample 1
	array(array(int)) a1 = ({ ({1, 2}), ({3, 4}) });
	array(array(int)) b1 = ({ ({0, 5}), ({6, 7}) });
	
	//Sample 2
	array(array(int)) a2 = ({ ({0, 1, 0}), ({1, 1, 1}), ({0, 1, 0}) });
	array(array(int)) b2 = ({ ({1, 1, 1, 1}), ({1, 0, 0, 1}), ({1, 1, 1, 1}) });

	array result1 = kronecker(a1, b1);
	for (int i = 0; i < sizeof(result1); i++) {
		foreach(result1[i], int result) {
			write((string)result + " ");
		}
		write("\n");
	}

	write("\n");

	array result2 = kronecker(a2, b2);
	for (int i = 0; i < sizeof(result2); i++) {
		foreach(result2[i], int result) {
			write((string)result + " ");
		}
		write("\n");
	}

	return 0;
}
