#include <extensions/embed.h>

extern unsigned char repl[];
int Query(char *Data, size_t *Length) {
	ol_t ol;
	embed_new(&ol, repl, 0);

	embed_eval(&ol, new_string(&ol,
		"(import (otus ffi))"
		"(define lib (load-dynamic-library #f))"
		"(define memcpy (lib fft-void* \"memcpy\" fft-void* type-string fft-int))"
		"(define (Query Data Length)"
		"   (define sample (c-string \"Here am I\"))"
		"   (when (memcpy Data sample (min (string-length sample) Length))"
		"      (min (string-length sample) Length)))"
	), 0);
	word r =
	embed_eval(&ol, new_string(&ol, "Query"), new_vptr(&ol, Data), make_integer(*Length), 0);
	if (!is_number(r))
		goto fail;
	*Length = ol2int(r);
	
	OL_free(ol.vm);
	return 1;

fail:
	OL_free(ol.vm);
	return 0;
}
