#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <confini.h>

#define rosetta_uint8_t unsigned char

#define FALSE 0
#define TRUE 1

#define CONFIGS_TO_READ 5
#define INI_ARRAY_DELIMITER ','

/* Assume that the config file represent a struct containing all the parameters to load */
struct configs {
	char *fullname;
	char *favouritefruit;
	rosetta_uint8_t needspeeling;
	rosetta_uint8_t seedsremoved;
	char **otherfamily;
	size_t otherfamily_len;
	size_t _configs_left_;
};

static char ** make_array (size_t * arrlen, const char * src, const size_t buffsize, IniFormat ini_format) {

	/* Allocate a new array of strings and populate it from the stringified source */
	*arrlen = ini_array_get_length(src, INI_ARRAY_DELIMITER, ini_format);
	char ** const dest = *arrlen ? (char **) malloc(*arrlen * sizeof(char *) + buffsize) : NULL;
	if (!dest) { return NULL; }
	memcpy(dest + *arrlen, src, buffsize);
	char * iter = (char *) (dest + *arrlen);
	for (size_t idx = 0; idx < *arrlen; idx++) {
		dest[idx] = ini_array_release(&iter, INI_ARRAY_DELIMITER, ini_format);
		ini_string_parse(dest[idx], ini_format);
	}
	return dest;

}

static int configs_member_handler (IniDispatch *this, void *v_confs) {

	struct configs *confs = (struct configs *) v_confs;

	if (this->type != INI_KEY) {

		return 0;

	}

	if (ini_string_match_si("FULLNAME", this->data, this->format)) {

		if (confs->fullname) { return 0; }
		this->v_len = ini_string_parse(this->value, this->format); /* Remove all quotes, if any */
		confs->fullname = strndup(this->value, this->v_len);
		confs->_configs_left_--;

	} else if (ini_string_match_si("FAVOURITEFRUIT", this->data, this->format)) {

		if (confs->favouritefruit) { return 0; }
		this->v_len = ini_string_parse(this->value, this->format); /* Remove all quotes, if any */
		confs->favouritefruit = strndup(this->value, this->v_len);
		confs->_configs_left_--;

	} else if (ini_string_match_si("NEEDSPEELING", this->data, this->format)) {

		if (~confs->needspeeling & 0x80) { return 0; }
		confs->needspeeling = ini_get_bool(this->value, TRUE);
		confs->_configs_left_--;

	} else if (ini_string_match_si("SEEDSREMOVED", this->data, this->format)) {

		if (~confs->seedsremoved & 0x80) { return 0; }
		confs->seedsremoved = ini_get_bool(this->value, TRUE);
		confs->_configs_left_--;

	} else if (!confs->otherfamily && ini_string_match_si("OTHERFAMILY", this->data, this->format)) {

		if (confs->otherfamily) { return 0; }
		this->v_len = ini_array_collapse(this->value, INI_ARRAY_DELIMITER, this->format); /* Save memory (not strictly needed) */
		confs->otherfamily = make_array(&confs->otherfamily_len, this->value, this->v_len + 1, this->format);
		confs->_configs_left_--;

	}

	/* Optimization: stop reading the INI file when we have all we need */
	return !confs->_configs_left_;

}

static int populate_configs (struct configs * confs) {

	/* Define the format of the configuration file */
	IniFormat config_format = {
		.delimiter_symbol = INI_ANY_SPACE,
		.case_sensitive = FALSE,
		.semicolon_marker = INI_IGNORE,
		.hash_marker = INI_IGNORE,
		.multiline_nodes = INI_NO_MULTILINE,
		.section_paths = INI_NO_SECTIONS,
		.no_single_quotes = FALSE,
		.no_double_quotes = FALSE,
		.no_spaces_in_names = TRUE,
		.implicit_is_not_empty = TRUE,
		.do_not_collapse_values = FALSE,
		.preserve_empty_quotes = FALSE,
		.disabled_after_space = TRUE,
		.disabled_can_be_implicit = FALSE
	};

	*confs = (struct configs) { NULL, NULL, 0x80, 0x80, NULL, 0, CONFIGS_TO_READ };

	if (load_ini_path("rosetta.conf", config_format, NULL, configs_member_handler, confs) & CONFINI_ERROR) {

		fprintf(stderr, "Sorry, something went wrong :-(\n");
		return 1;

	}

	confs->needspeeling &= 0x7F;
	confs->seedsremoved &= 0x7F;

	return 0;

}

int main () {

	struct configs confs;

	ini_global_set_implicit_value("YES", 0);

	if (populate_configs(&confs)) {

		return 1;

	}

	/* Print the configurations parsed */

	printf(

		"Full name: %s\n"
		"Favorite fruit: %s\n"
		"Need spelling: %s\n"
		"Seeds removed: %s\n",

		confs.fullname,
		confs.favouritefruit,
		confs.needspeeling ? "True" : "False",
		confs.seedsremoved ? "True" : "False"

	);

	for (size_t idx = 0; idx < confs.otherfamily_len; idx++) {

		printf("Other family[%d]: %s\n", idx, confs.otherfamily[idx]);

	}

	/* Free the allocated memory */

	#define FREE_NON_NULL(PTR) if (PTR) { free(PTR); }

	FREE_NON_NULL(confs.fullname);
	FREE_NON_NULL(confs.favouritefruit);
	FREE_NON_NULL(confs.otherfamily);

	return 0;

}
