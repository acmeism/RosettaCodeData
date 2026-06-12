#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <errno.h>

static void usage(FILE *out) {
	fputs("use: sfipp [OPTION] [FILE]\n", out);
	fputs("OPTION:\n", out);
	fputs("-h, --help           display help\n", out);
	fputs("-o, --output FILE    output to FILE\n", out);
}

enum { C_SOURCE_LINE_LENGTH = 4095 }; // as per the C standard

struct included {
	char            const *filename;
	struct included const *prev;
};

static char const *findincludefile(int type, char *pathbuf, char const *filename, int len) {
	// exclude from search file names with absolute direcories
	if(isalpha(filename[0]) && (filename[1] == ':') && (filename[2] == '/')) { // windows style path
		return filename;
	}
	if(filename[0] == '/') { // uinix style path
		return filename;
	}
	// exclude from search file names with relative directories
	if(filename[0] == '.') {
		if(filename[1] == '/') { // current directory
			return filename;
		}
		if((filename[1] == '.') && (filename[2] == '/')) { // previous directory
			return filename;
		}
	}
	// search paths in INCLUDE environment variable
	char const *include = getenv("INCLUDE");
	if(!include) {
		return filename;
	}
	// move filename to end of path buffer,
	// paths can be simply copied into the preceeding buffer space
	memmove(pathbuf + C_SOURCE_LINE_LENGTH - len, filename, len + 1);
	len = C_SOURCE_LINE_LENGTH - len;

	if(type == '"') {
		// check for local file first
		for(FILE *fp = fopen(filename, "r"); fp; ) {
			fclose(fp);
			return filename;
		}
	}
	for(int n; include[0]; include += n) {
		n = 0;
		// extract path from INCLUDE
		if(isalpha(include[0]) && (include[1] == ':') && (include[2] == '/')) {
			// windows style path
			n += 3;
		}
		for(; include[n] && (include[n] != ':'); n++)
			;
		int q = (n > 0) && (include[n-1] != '/');
		int m = len - q;
		if(n <= m) {
			// insert directory separator if required
			if(q) {
				pathbuf[m] = '/';
			}
			// prepend path to file name
			filename = memcpy(pathbuf + (m - n), include, n);
			for(FILE *fp = fopen(filename, "r"); fp; ) {
				fclose(fp);
				return filename;
			}
			if(include[n] == ':') {
				n++;
			}
			continue;
		}
		fprintf(stderr, "INCLUDE path too long: %.*s\n", n, include);
		if(include[n] == ':') {
			n++;
		}
	}
	// file not found
	return NULL;
}

static int preprocessfile(struct included const *inclp, char const *filename, FILE *out);

static int preprocess(struct included const *incl, FILE *in, FILE *out) {
	int failed = 0;
	int lineno = 1;
	// indicate start of new file in output
	fprintf(out, "#line 1 \"%s\"\n", incl->filename);
	for(; lineno > 0; lineno++) {
		int c;
		char line[C_SOURCE_LINE_LENGTH+1];
		char const *cs = fgets(line, sizeof(line), in);
		if(!cs) break;
		// check for newline character
		if(!strchr(cs, '\n')) {
			fprintf(stderr, "%s#%i: line too long", incl->filename, lineno);
			failed = 1;
			// elide the remainder of the line
			for(c = fgetc(in); (c != EOF) && (c != '\n'); c = fgetc(in))
				;
			if(c == EOF) break;
			continue;
		}
		// skip leading space
		for(; (c = *cs) && isspace(c); c = *cs++)
			;
		// leading '#' indicates a C preprocessor directive
		if(c == '#') {
			// skip intermediate space
			for(cs++; (c = *cs) && isspace(c); cs++)
				;
			// scan directive identifier
			char const *directive = cs;
			for(; (c = *cs) && isalpha(c) || (c == '_'); cs++)
				;
			size_t n = cs - directive;
			if((n == 7) && (strncmp(directive, "include", n) == 0)) {
				// skip intermediate space
				for(; (c = *cs) && isspace(c); cs++)
					;
				// determine include variant, and, filename terminator
				int const e = (c == '<') ? '>' : (c == '"') ? '"' : 0;
				if(e != 0) {
					char const *filename = ++cs;
					// find end of filename
					for(; (c = *cs) && (c != e); cs++)
						;
					if(c == e) {
						line[cs - line] = '\0'; // nul terminate filename
						filename = findincludefile(e, line, filename, cs - filename);
						if(filename) {
							failed = failed | preprocessfile(incl, filename, out);
							// restore filename and line number in output
							fprintf(out, "#line %i \"%s\"\n", lineno + 1, incl->filename);
							continue;
						}
						fprintf(stderr, "%s#%i: unknown include file\n", incl->filename, lineno);
						failed = 1;
						continue;
					}
				}
				fprintf(stderr, "%s#%i: invalid include directive\n", incl->filename, lineno);
				failed = 1;
				continue;
			}
		}
		// output all non-include lines
		fputs(line, out);
	}
	if(ferror(in)) {
		fprintf(stderr, "%s#%i: %s", incl->filename, lineno, strerror(errno));
		failed = 1;
	}
	return failed;
}

#define DEFER(DEFER_pre,DEFER_cond,DEFER_post) \
	for(int DEFER##__LINE__ = 1; DEFER##__LINE__; DEFER##__LINE__ = 0) \
		for(DEFER_pre; DEFER##__LINE__ && (DEFER_cond); (DEFER_post), DEFER##__LINE__ = 0)

static int preprocessfile(struct included const *inclp, char const *filename, FILE *out) {
	// detect and inhibit recursive include
	for(struct included const *prev = inclp; prev; prev = prev->prev) {
		if(strcmp(prev->filename, filename) == 0) {
			return 0;
		}
	}
	int failed;
	DEFER(FILE *in = filename ? fopen(filename, "r") : stdin,
		!(failed = !in) || (perror(filename), false),
		(in != stdin) ? fclose(in) : (void)0
	) {
		struct included const incl = {
			.filename = filename ? filename : "stdin",
			.prev = inclp
		};
		failed = failed | preprocess(&incl, in, out);
	}
	fflush(out);
	return failed;
}

#define OPTION(OPTION__args,OPTION__short,...)  \
		if((*(OPTION__short) && !strcmp((OPTION__args), ("-"OPTION__short))) \
			|| (*(__VA_ARGS__"") && !strcmp((OPTION__args), ("--"__VA_ARGS__""))))

int main(int argc, char **argv) {
	int argi = 1;
	char const *outfile = NULL;
	while((argi < argc) && (*argv[argi] == '-')) {
		char const *args = argv[argi];
		OPTION(args, "h", "help") {
			argi++;
			usage(stdout);
			return EXIT_SUCCESS;
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
	int failed;
	DEFER(FILE *out = outfile ? fopen(outfile, "w") : stdout,
		!(failed = !out) || (perror(outfile), false),
		(out != stdout) ? fclose(out) : (void)0
	) do {
		char const *infile = (argi < argc) ? argv[argi++] : NULL;
		failed = failed | preprocessfile(NULL, infile, out);
	} while(argi < argc)
		;
	return failed ? EXIT_FAILURE : EXIT_SUCCESS;
}

