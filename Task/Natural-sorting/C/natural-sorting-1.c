#include <stdio.h>
#include <stdlib.h>
#include <wchar.h>
#include <wctype.h>
#include <string.h>
#include <locale.h>

typedef struct wstr {
	wchar_t *s;
	int n, alloc;
} wstr;

#define w_del(w) { free(w->s); free(w); }
#define forchars(i, c, w) for(i = 0, c = w->s[0]; i < w->n && c; c = w->s[++i])
wstr *w_new()
{
	wstr *w = malloc(sizeof(wstr));
	w->alloc = 1;
	w->n = 0;
	w->s = malloc(sizeof(wchar_t));
	w->s[0] = 0;
	return w;
}

void w_append(wstr *w, wchar_t c)
{
	int n = w->n + 1;
	if (n >= w->alloc) {
		w->alloc *= 2;
		w->s = realloc(w->s, w->alloc * sizeof(wchar_t));
	}
	w->s[w->n++] = c;
	w->s[w->n] = 0;
}

wstr *w_make(wchar_t *s)
{
	int i, len = wcslen(s);
	wstr *w = w_new();
	for (i = 0; i < len; i++) w_append(w, s[i]);
	return w;
}

typedef void (*wtrans_func)(wstr *, wstr *);
void w_transform(wstr *in, wtrans_func f)
{
	wstr t, *out = w_new();
	f(in, out);
	t = *in; *in = *out; *out = t;
	w_del(out);
}
#define transfunc(x) void w_##x(wstr *in, wstr *out)

transfunc(nocase) {
	int i;
	wchar_t c;
	forchars(i, c, in) w_append(out, towlower(c));
}

transfunc(despace) {
	int i, gotspace = 0;
	wchar_t c;
	forchars(i, c, in) {
		if (!iswspace(c)) {
			if (gotspace && out->n)
				w_append(out, L' ');
			w_append(out, c);
			gotspace = 0;
		} else	gotspace = 1;
	}
}

static const wchar_t *const tbl_accent[] = { /* copied from Perl6 code */
	L"Þ", L"TH", L"þ", L"th", L"Ð", L"TH", L"ð", L"th", L"À", L"A",
	L"Á", L"A", L"Â", L"A", L"Ã", L"A", L"Ä", L"A", L"Å", L"A", L"à",
	L"a", L"á", L"a", L"â", L"a", L"ã", L"a", L"ä", L"a", L"å", L"a",
	L"Ç", L"C", L"ç", L"c", L"È", L"E", L"É", L"E", L"Ê", L"E", L"Ë",
	L"E", L"è", L"e", L"é", L"e", L"ê", L"e", L"ë", L"e", L"Ì",
	L"I", L"Í", L"I", L"Î", L"I", L"Ï", L"I", L"ì", L"i", L"í",
	L"i", L"î", L"i", L"ï", L"i", L"Ò", L"O", L"Ó", L"O", L"Ô",
	L"O", L"Õ", L"O", L"Ö", L"O", L"Ø", L"O", L"ò", L"o", L"ó", L"o",
	L"ô", L"o", L"õ", L"o", L"ö", L"o", L"ø", L"o", L"Ñ", L"N", L"ñ", L"n",
	L"Ù", L"U", L"Ú", L"U", L"Û", L"U", L"Ü", L"U", L"ù", L"u", L"ú", L"u",
	L"û", L"u", L"ü", L"u", L"Ý", L"Y", L"ÿ", L"y", L"ý", L"y" };

static const wchar_t *const tbl_ligature[] = {
	L"Æ", L"AE", L"æ", L"ae", L"ß", L"ss",
	L"ﬄ", L"ffl", L"ﬃ", L"ffi", L"ﬁ", L"fi", L"ﬀ", L"ff", L"ﬂ", L"fl",
	L"ſ", L"s", L"ʒ", L"z", L"ﬆ", L"st", /* ... come on ... */
};

void w_char_repl(wstr *in, wstr *out, const wchar_t *const *tbl, int len)
{
	int i, j, k;
	wchar_t c;
	forchars(i, c, in) {
		for (j = k = 0; j < len; j += 2) {
			if (c != tbl[j][0]) continue;
			for (k = 0; tbl[j + 1][k]; k++)
				w_append(out, tbl[j + 1][k]);
			break;
		}
		if (!k) w_append(out, c);
	}
}

transfunc(noaccent) {
	w_char_repl(in, out, tbl_accent, sizeof(tbl_accent)/sizeof(wchar_t*));
}

transfunc(noligature) {
	w_char_repl(in, out, tbl_ligature, sizeof(tbl_ligature)/sizeof(wchar_t*));
}

static const wchar_t *const tbl_article[] = {
	L"the", L"a", L"of", L"to", L"is", L"it" };
#define N_ARTICLES sizeof(tbl_article)/sizeof(tbl_article[0])
transfunc(noarticle) {
	int i, j, n;
	wchar_t c, c0 = 0;
	forchars(i, c, in) {
		if (!c0 || (iswalnum(c) && !iswalnum(c0))) { /* word boundary */
			for (j = N_ARTICLES - 1; j >= 0; j--) {
				n = wcslen(tbl_article[j]);
				if (wcsncasecmp(in->s + i, tbl_article[j], n))
					continue;
				if (iswalnum(in->s[i + n])) continue;
				i += n;
				break;
			}
			if (j < 0) w_append(out, c);
		} else
			w_append(out, c);
		c0 = c;
	}
}

enum { wi_space = 0, wi_case, wi_accent, wi_lig, wi_article, wi_numeric };
#define WS_NOSPACE	(1 << wi_space)
#define WS_NOCASE	(1 << wi_case)
#define WS_ACCENT	(1 << wi_accent)
#define WS_LIGATURE	(1 << wi_lig)
#define WS_NOARTICLE	(1 << wi_article)
#define WS_NUMERIC	(1 << wi_numeric)
const wtrans_func trans_funcs[] = {
	w_despace, w_nocase, w_noaccent, w_noligature, w_noarticle, 0
};
const char *const flagnames[] = {
	"collapse spaces",
	"case insensitive",
	"disregard accent",
	"decompose ligatures",
	"discard common words",
	"numeric",
};

typedef struct { wchar_t* s; wstr *w; } kw_t;
int w_numcmp(const void *a, const void *b)
{
	wchar_t *pa = ((const kw_t*)a)->w->s, *pb = ((const kw_t*)b)->w->s;
	int sa, sb, ea, eb;
	while (*pa && *pb) {
		if (iswdigit(*pa) && iswdigit(*pb)) {
			/* skip leading zeros */
			sa = sb = 0;
			while (pa[sa] == L'0') sa++;
			while (pb[sb] == L'0') sb++;
			/* find end of numbers */
			ea = sa; eb = sb;
			while (iswdigit(pa[ea])) ea++;
			while (iswdigit(pb[eb])) eb++;
			if (eb - sb > ea - sa) return -1;
			if (eb - sb < ea - sa) return 1;
			while (sb < eb) {
				if (pa[sa] > pb[sb]) return 1;
				if (pa[sa] < pb[sb]) return -1;
				sa++; sb++;
			}

			pa += ea; pb += eb;
		}
		else if (iswdigit(*pa)) return 1;
		else if (iswdigit(*pb)) return -1;
		else {
			if (*pa > *pb) return 1;
			if (*pa < *pb) return -1;
			pa++; pb++;
		}
	}
	return (!*pa && !*pb) ? 0 : *pa ?  1 : -1;
}

int w_cmp(const void *a, const void *b)
{
	return wcscmp(((const kw_t*)a)->w->s, ((const kw_t*)b)->w->s);
}

void natural_sort(wchar_t **strings, int len, int flags)
{
	int i, j;
	kw_t *kws = malloc(sizeof(kw_t) * len);

	for (i = 0; i < len; i++) {
		kws[i].s = strings[i];
		kws[i].w = w_make(strings[i]);
		for (j = 0; j < wi_numeric; j++)
			if (flags & (1 << j) && trans_funcs[j])
				w_transform(kws[i].w, trans_funcs[j]);
	}

	qsort(kws, len, sizeof(kw_t), (flags & WS_NUMERIC) ? w_numcmp : w_cmp);
	for (i = 0; i < len; i++) {
		w_del(kws[i].w);
		strings[i] = kws[i].s;
	}
	free(kws);
}

const wchar_t *const test[] = {
	L" 0000098 nina", L"100 niño", L"99 Ninja", L"100 NINA",
	L" The work is so diﬃcult to do it took ſome 100 aeons.  ",
	L"The work is so difficult it took some 100 aeons.",
	L"  The work is so diﬃcult   it took ſome 99 æons.  ",
};
#define N_STRINGS sizeof(test)/sizeof(*test)

void test_sort(int flags)
{
	int i, j;
	const wchar_t *str[N_STRINGS];
	memcpy(str, test, sizeof(test));

	printf("Sort flags: (");
	for (i = 0, j = flags; j; i++, j >>= 1)
		if ((j & 1))
			printf("%s%s", flagnames[i], j > 1 ? ", ":")\n");

	natural_sort((wchar_t **)str, N_STRINGS, flags);

	for (i = 0; i < N_STRINGS; i++)
		printf("%ls\n", str[i]);
	printf("\n");
}

int main()
{
	setlocale(LC_CTYPE, "");

	test_sort(WS_NOSPACE);
	test_sort(WS_NOCASE);
	test_sort(WS_NUMERIC);
	test_sort(WS_NOARTICLE|WS_NOSPACE);
	test_sort(WS_NOCASE|WS_NOSPACE|WS_ACCENT);
	test_sort(WS_LIGATURE|WS_NOCASE|WS_NOSPACE|WS_NUMERIC|WS_ACCENT|WS_NOARTICLE);

	return 0;
}
