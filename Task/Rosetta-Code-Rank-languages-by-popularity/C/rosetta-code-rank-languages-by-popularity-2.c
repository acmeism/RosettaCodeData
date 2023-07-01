#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>
#include "cJSON.h"
char *URL_BASE = "http://www.rosettacode.org/mw/api.php?format=json&action=query&generator=categorymembers&gcmtitle=Category:Programming%20Languages&gcmlimit=500&prop=categoryinfo&rawcontinue";
char *URL_BASE_CONT = "http://www.rosettacode.org/mw/api.php?format=json&action=query&generator=categorymembers&gcmtitle=Category:Programming%20Languages&gcmlimit=500&prop=categoryinfo&gcmcontinue=";

typedef struct mem {
	char *text;
	size_t size;
} mem;

typedef struct page {
	char *name;
	int num;
} page;

size_t write_callback(void *ptr, size_t size, size_t nmemb, void *userdata);
void curl_request(CURL *curl, char *url, mem *response);
char *build_url(char *cont);
char *get_cont(cJSON *json);
void sort_arrays(page *pages, int *s);
cJSON *parse_json(cJSON *json);
page *fill_arrays(page *pages, int *s, cJSON *json);

int main(int argc, char *argv[]) {
	curl_global_init(CURL_GLOBAL_ALL);
	CURL *curl = curl_easy_init();
	char *cont = NULL;
	page *pages = malloc(1);
	int till = 10;
	int *npag = malloc(sizeof(int));
	*npag = 0;
	if (argc>1) till = atoi(argv[1]);
	do {
		mem *response = calloc(1, sizeof(mem));	
		char *url = build_url(cont);
		if (cont) free(cont);
		curl_request(curl, url, response);
		cJSON *json = cJSON_Parse(response->text);
		cont = get_cont(json);
		cJSON *json_pages = parse_json(json);
		pages = fill_arrays(pages, npag, json_pages);			
		cJSON_Delete(json);
		free(url);
		free(response->text);
		free(response);
	} while (cont);
	sort_arrays(pages, npag);
	if (till>*npag||till<-1) till=10;
	if (till==-1) till=*npag;
	for (int i = 0;i<till;i++) {
		printf("#%d: %s, %d tasks\n", i+1, pages[i].name, pages[i].num);
	}
	for (int i = 0;i<*npag;i++) {
		free(pages[i].name);
	}
	free(pages);
	free(npag);
	curl_easy_cleanup(curl);
	curl_global_cleanup();
	return 0;
}
size_t write_callback(void *ptr, size_t size, size_t nmemb, void *userdata) {
	mem *response = userdata;
	response->text = realloc(response->text, response->size+size*nmemb+1);
	memcpy(&(response->text[response->size]), ptr, size*nmemb);
	response->size += size*nmemb;
	response->text[response->size] = '\0';
	return size*nmemb;
}
void curl_request(CURL *curl, char *url, mem *response) {
	curl_easy_setopt(curl, CURLOPT_URL, url);
	curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_callback);
	curl_easy_setopt(curl, CURLOPT_WRITEDATA, response);
	curl_easy_perform(curl);
}
char *build_url(char *cont) {
	char *url;
	if (cont) {
		int size = strlen(URL_BASE_CONT)+strlen(cont)+1;
		url = calloc(1, size);
		strncpy(url, URL_BASE_CONT, strlen(URL_BASE_CONT));
		strcat(url, cont);		
	} else {
		url = malloc(strlen(URL_BASE)+1);
		strcpy(url, URL_BASE);
	}
	return url;
}
cJSON *parse_json(cJSON *json) {
	cJSON *pages;
	if (json) {
		pages = cJSON_GetObjectItem(json, "query");
		pages = cJSON_GetObjectItem(pages, "pages");	
		pages = pages->child;
	}
	return pages;
}
char *get_cont(cJSON *json) {
	cJSON *jcont = cJSON_GetObjectItem(json, "query-continue");
	if (jcont && jcont->child->child) {
		char *cont = malloc(strlen(jcont->child->child->valuestring)+1);
		strcpy(cont, jcont->child->child->valuestring);
		return cont;
	} else {
		return NULL;
	}
}
page *fill_arrays(page *pag, int *i, cJSON *json) {
	cJSON *cur_page = json;
	page *pages = pag;
	do {
		pages = realloc(pages, *i*sizeof(page)+sizeof(page));
		if (json->child) {
			int size = strlen(cur_page->child->next->next->valuestring)-9;
			char *lang = malloc(size+1);
			strcpy(lang, cur_page->child->next->next->valuestring+9);
			pages[*i].name = lang;
		} else {
			pages[*i].name = "no name";
		}
		int task = cur_page->child->next->next->next?cur_page->child->next->next->next->child->valueint:0;
		pages[*i].num = task;
		*i = *i+1;
		cur_page = cur_page->next;
	} while (cur_page->next);
	return pages;
}
void sort_arrays(page *pages, int *size) {
	int sorted = 0;
	do {
		sorted = 1;
		for (int i = 0;i<*size-1;i++) {
			if (pages[i].num<pages[i+1].num) {
				sorted = 0;
				int a = pages[i+1].num;
				pages[i+1].num = pages[i].num;
				pages[i].num = a;
				char *s = pages[i+1].name;
				pages[i+1].name = pages[i].name;
				pages[i].name = s;
			}
		}
	} while (sorted!=1);
}
