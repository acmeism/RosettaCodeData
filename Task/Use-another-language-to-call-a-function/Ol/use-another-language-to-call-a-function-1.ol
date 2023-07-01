#include <extensions/embed.h>

#define min(x,y) (x < y ? x : y)

extern unsigned char repl[];
int Query(char *Data, size_t *Length) {
	ol_t ol;
	embed_new(&ol, repl, 0);

	word s = embed_eval(&ol, new_string(&ol,
		"(define sample \"Here am I\")"
		"sample"
	), 0);
	if (!is_string(s))
		goto fail;

	int i = *Length = min(string_length(s), *Length);

	memcpy(Data, string_value(s), i);
	*Length = i;

	OL_free(ol.vm);
	return 1;
fail:
	OL_free(ol.vm);
	return 0;
}
