#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <errno.h>
#include <time.h>

static void usage(FILE *out) {
	fputs("use: 1tp [OPTION] FILE COMMAND [...]\n", out);
	fputs("OPTION:\n", out);
	fputs("\t-h, --help           display help\n", out);
	fputs("\t-m, --morse          use morse code alphabet\n", out);
	fputs("\t-p, --pad            pad encrypted text\n", out);
	fputs("\t-f, --file           text is read from a file\n", out);
	fputs("\t-o, --output FILE    write en/de-crypted text to FILE\n", out);
	fputs("COMMAND:\n", out);
	fputs("\t-g, --generate [PAGES [ROWS [COLS [DIGITS]]]]\n", out);
	fputs("\t-e, --encrypt [PAGE] [TEXT]\n", out);
	fputs("\t-d, --decrypt [PAGE] [TEXT]\n", out);
	fputs("\t-r, --remove\n", out);
}

#ifdef _WIN32
#include <winternl.h>
#include <bcrypt.h>
ssize_t getrandom(void *buf, size_t buflen, unsigned int flags) {
	(void)flags;
	ssize_t z = -1;
	NTSTATUS s = BCryptGenRandom(NULL, buf, buflen, BCRYPT_USE_SYSTEM_PREFERRED_RNG);
	if(NT_SUCCESS(s)) {
		z = (ssize_t)buflen;
	} else {
		errno = EINVAL;
	}
	return z;
}
#else	// Linux &c
#include <sys/random.h>
#endif//def _WIN32

enum { DIGITS_PER_COLUMN = 5 };
enum { RANDOM_BLOCK_SIZE = 256 };
enum { DIGIT_ERASE_CHAR = '-' };
enum { COMMENT_CHAR = '#' };

static char const *filename1tp(char const *cs) {
	size_t n = strlen(cs);
	if((n < 4) || (strcmp(cs + n - 4, ".1tp") != 0)) {
		char *s = malloc(n + 4 + 1);
		if(!s) {
			perror("");
			abort();
		}
		cs = strcat(strcpy(s, cs), ".1tp");
	}
	return cs;
}

static int generate1tp(FILE *otp, char const *alphabet, size_t pages, size_t rows, size_t cols, size_t digits, char const *filename) {
	int failed = 0;
	do {
		size_t const sizeof_alphabet = strlen(alphabet);
		size_t count = pages * rows * cols * digits;
		if((((count / pages) / rows) / cols) != digits) {
			fputs("pad too big\n", stderr);
			break;
		}
		time_t t = time(NULL);
		struct tm utc = *gmtime(&t);
		int r = fprintf(otp, "# %i/%.2i/%.2i-%.2i:%.2i:%.2i\n",
			1900 + utc.tm_year, utc.tm_mon + 1, utc.tm_mday,
			utc.tm_hour, utc.tm_min, utc.tm_sec
		);
		if((r > 0) && (pages > 1)) {
			r = fprintf(otp, "#[1]\n");
		}
		if((failed = r < 0)) {
			perror(filename);
			break;
		}
		size_t const threshold = -sizeof_alphabet % sizeof_alphabet;
		for(size_t p = 1, r = 0, c = 0, d = 0;
			!failed && (r < rows) && (count > 0);
			count--
		) {
			int x;
			// get random alphabet using Lemire's debiased integer multiplication method
			// https://lemire.me/blog/2019/06/06/nearly-divisionless-random-integer-generation-on-various-systems/
			for(;;) {
				static int n = 0;
				static unsigned char randombyte[RANDOM_BLOCK_SIZE];
				if(n == 0) {
					if(getrandom(randombyte, RANDOM_BLOCK_SIZE, 0) < 0) {
						perror("");
						return -1;
					}
					n = RANDOM_BLOCK_SIZE;
				}
				n--;
				size_t r = randombyte[n];
				size_t m = r * sizeof_alphabet;
				size_t l = m % (1 << CHAR_BIT);
				if(l >= threshold) {
					x = m >> CHAR_BIT;
					break;
				}
			}
			int a = alphabet[x];
			if((failed = fputc(a, otp) != a)) {
				perror(filename);
				break;
			}
			if(++d == digits) {
				d = 0;
				if(++c == cols) {
					c = 0;
					if((failed = fputc('\n', otp) != '\n')) {
						perror(filename);
						break;
					}
					if(++r == rows) {
						r = 0;
						if(++p > pages) { // > because page numbers run from 1..N
							break;
						}
						fprintf(otp, "#[%zu]\n", p);
					}
				} else {
					if((failed = fputc(' ', otp) != ' ')) {
						perror(filename);
						break;
					}
				}
			}
		}
		fflush(otp);
	} while(0)
		;
	return failed;
}

static int load1tp(FILE *otp, char **sp, size_t *lenp, char const *filename) {
	rewind(otp);
	int failed = 0;
	do {
		failed = fseek(otp, 0, SEEK_END) != 0;
		if(failed) break;
		long n = ftell(otp);
		if((failed = n < 0)) break;
		size_t len = n;
		char *s = calloc(len + 1, 1);
		*sp = s;
		if(!s) {
			perror("");
			abort();
		}
		rewind(otp);
		len = fread(s, 1, len, otp);
		if((failed = ferror(otp))) break;
		*lenp = len;
	} while(0)
		;
	if(failed) {
		perror(filename);
	}
	return failed;
}

static int save1tp(FILE *otp, char const *cs, size_t len, char const *filename) {
	rewind(otp);
	fwrite(cs, 1, len, otp);
	int failed = ferror(otp);
	if(failed) {
		perror(filename);
	}
	return failed;
}

static char const *getmessage(char *message, int asfile) {
	if(asfile) {
		char const *filename = message;
		FILE *in = strcmp(filename, "-'") ? fopen(filename, "r") : stdin;
		if(!in) {
			perror(filename);
			return NULL;
		}
		size_t n = 0;
		size_t z = BUFSIZ-1;
		message = malloc(BUFSIZ);
		if(!message) {
			perror("");
			abort();
		}
		do {
			size_t u = fread(message + n, 1, z - n, in);
			if(ferror(in)) {
				perror(filename);
				return NULL;
			}
			n += u;
			if(n == z) {
				z += BUFSIZ;
				message = realloc(message, z + 1);
				if(!message) {
					perror(filename);
					abort();
				}
			}
		} while(!feof(in))
			;
		message[n] = '\0';
		if(in != stdin) {
			fclose(in);
		}
	}
	return message;
}

#define OPTION(OPTION__args,OPTION__short,...)  \
	if((*(OPTION__short) && !strcmp((OPTION__args), ("-"OPTION__short))) \
		|| (*(__VA_ARGS__"") && !strcmp((OPTION__args), ("--"__VA_ARGS__""))))

int main(int argc, char **argv) {
	char const *alphabet_characters = "_0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	char const *alphabet = strchr(alphabet_characters, 'A');
	int pad = 0;
	int asfile = 0;
	char const *outfile = NULL;
	FILE *out = stdout;

	int argi = 1;
	while((argi < argc) && (*argv[argi] == '-')) {
		char const *args = argv[argi];
		OPTION(args, "h", "help") {
			argi++;
			usage(stdout);
			return EXIT_SUCCESS;
		}
		OPTION(args, "m", "morse") {
			argi++;
			alphabet = strchr(alphabet_characters, '_');
			continue;
		}
		OPTION(args, "p", "pad") {
			argi++;
			pad = 1;
			continue;
		}
		OPTION(args, "f", "file") {
			argi++;
			asfile = 1;
			continue;
		}
		OPTION(args, "o", "output") {
			argi++;
			if(argi < argc) {
				outfile = argv[argi++];
				continue;
			}
		}
		usage(stderr);
		return EXIT_FAILURE;
	}
	if((argi + 2) > argc) {
		usage(stderr);
		return EXIT_FAILURE;
	}

	int failed = 0;
	size_t const sizeof_alphabet = strlen(alphabet);
	char const *filename = filename1tp(argv[argi++]);
	FILE *otp = NULL;
	char *s = NULL;
	size_t n = 0;
	if(outfile) {
		out = fopen(outfile, "w");
		failed = !out;
	}
	if(!failed) do {
		char const *command = argv[argi++];
		OPTION(command, "g", "generate") {
			size_t digits = DIGITS_PER_COLUMN;
			size_t cols   = DIGITS_PER_COLUMN;
			size_t rows   = cols * DIGITS_PER_COLUMN;
			size_t pages  = rows * DIGITS_PER_COLUMN;
			if(argi < argc) {
				pages = strtoul(argv[argi++], NULL, 10);
				if((failed |= !pages)) {
					fputs("invalid number of pages\n", stderr);
				}
			}
			if(argi < argc) {
				rows = strtoul(argv[argi++], NULL, 10);
				if((failed |= !rows)) {
					fputs("invalid number of rows\n", stderr);
				}
			}
			if(argi < argc) {
				cols = strtoul(argv[argi++], NULL, 10);
				if((failed |= !cols)) {
					fputs("invalid number of columns\n", stderr);
				}
			}
			if(argi < argc) {
				digits = strtoul(argv[argi++], NULL, 10);
				if((failed |= !digits)) {
					fputs("invalid number of digits\n", stderr);
				}
			}
			if(failed) break;

			otp = fopen(filename, "w+");
			if((failed = !otp)) {
				perror(filename);
				break;
			}
			failed = generate1tp(otp, alphabet, pages, rows, cols, digits, filename);
			if(failed) break;
			continue;
		}

		// all other commands load the .1tp file
		otp = fopen(filename, "r+");
		if((failed = !otp)) {
			perror(filename);
			break;
		}
		failed = load1tp(otp, &s, &n, filename);
		if(failed) break;

		OPTION(command, "r", "remove") {
			// overwrite with zero before removing file
			memset(s, 0, n);
			failed = save1tp(otp, s, n, filename);
			fclose(otp);
			otp = NULL;
			remove(filename);
			continue;
		}

		// encrypt and decrypt share common code
		int direction = 0;
		OPTION(command, "e", "encrypt") {
			direction = 1;
		}
		OPTION(command, "d", "decrypt") {
			direction = -1;
		}
		if((failed = !direction)) {
			fputs("unknown command\n", stderr);
			break;
		}
		if((failed = argi >= argc)) {
			fputs("missing message\n", stderr);
			break;
		}
		char *t = s;
		if((argi + 1) < argc) {
			// select page
			char page[32];
			char *args = argv[argi++];
			sprintf(page, "#[%.28s]", args);
			t = strstr(s, page);
			if((failed = !t)) {
				fputs("invalid page number\n", stderr);
				break;
			}
		}
		char const *message = getmessage(argv[argi], asfile);
		if((failed = !message)) break;

		for(int c; (c = *message++); ) {
			c = toupper(c);
			char const *a = strchr(alphabet, c);
			if(!strchr(alphabet, c)) continue;
			// skip non-coding characters
			while((*t == ' ') || (*t == '\n')
				|| (*t == DIGIT_ERASE_CHAR) || (*t == COMMENT_CHAR)
			) {
				for(; (*t == ' ') || (*t == '\n'); t++)
					;
				while((*t == DIGIT_ERASE_CHAR) || (*t == COMMENT_CHAR)) {
					for(t++; *t && (*t != '\n'); t++)
						;
				}
			}
			if((failed = !*t)) {
				fputs("end of pad reached\n", stderr);
				break;
			}
			char const *b = strchr(alphabet, *t);
			int x = a - alphabet;
			int y = b - alphabet;
			x = (x + (sizeof_alphabet + (y * direction))) % sizeof_alphabet;
			c = alphabet[x];
			// erase used digit
			*t++ = DIGIT_ERASE_CHAR;
			if((failed = fputc(c, out) != c)) {
				perror(outfile);
				break;
			}
		}
		// erase remaining digits on row
		// optionally pad output to row length
		for(int c; (c = *t) && (c != '\n'); t++) {
			if(c != ' ') {
				if(pad && !failed) {
					if((failed = fputc(c, out) != c)) {
						perror(outfile);
					}
				}
				*t = DIGIT_ERASE_CHAR;
			}
		}
		failed |= save1tp(otp, s, n, filename);
	} while(0)
		;
	if(out != stdout) {
		fclose(out);
	}
	if(otp) {
		fclose(otp);
	}
	return failed ? EXIT_FAILURE : EXIT_SUCCESS;
}
