array cumu(int n) {
	array(array(int)) cache = ({({1})});

	for(int l = sizeof(cache); l < n + 1; l++) {
		array(int) r = ({0});
		for(int x = 1; x < l + 1; x++) {
			r = Array.push(r, r[-1] + cache[l - x][min(x, l-x)]);
		}
		cache = Array.push(cache, r);
	}
	return cache[n];
}

array row(int n) {
	array r = cumu(n);
	array res = ({});
	for (int i = 0; i < n; i++) {
		res = Array.push(res, r[i+1] - r[i]);
	}
	return res;
}

int main() {
	write("rows:\n");
	for(int x = 1; x < 11; x++) {
		write("%2d: ", x);
		for(int i = 0; i < sizeof(row(x)); i++) {
			write((string)row(x)[i] + " ");
		}
		write("\n");
	}

	array(int) sum_n = ({23, 123, 1234, 12345});
	write("\nsums:\n");
	for (int x = 0; x < sizeof(sum_n); x++) {
		write((string)sum_n[x] + " " + (string)cumu(sum_n[x])[-1] + "\n");
	}
	return 0;
}
