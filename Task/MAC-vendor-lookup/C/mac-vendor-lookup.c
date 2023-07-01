#include <curl/curl.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

/* Length of http://api.macvendors.com/ */
#define FIXED_LENGTH 16

struct MemoryStruct {
  char *memory;
  size_t size;
};

static size_t WriteMemoryCallback(void *contents, size_t size, size_t nmemb, void *userp)
{
  size_t realsize = size * nmemb;
  struct MemoryStruct *mem = (struct MemoryStruct *)userp;

  mem->memory = realloc(mem->memory, mem->size + realsize + 1);

  memcpy(&(mem->memory[mem->size]), contents, realsize);
  mem->size += realsize;
  mem->memory[mem->size] = 0;

  return realsize;
}

void checkResponse(char* str){
	char ref[] = "Vendor not found";
	int len = strlen(str),flag = 1,i;
	
	if(len<16)
		fputs(str,stdout);
	else{
		for(i=0;i<len && i<16;i++)
			flag = flag && (ref[i]==str[i]);
		
		flag==1?fputs("N/A",stdout):fputs(str,stdout);
	}
}

int main(int argC,char* argV[])
{
		if(argC!=2)
			printf("Usage : %s <MAC address>",argV[0]);
		else{
			CURL *curl;
			int len = strlen(argV[1]);
			char* str = (char*)malloc((FIXED_LENGTH + len)*sizeof(char));
			struct MemoryStruct chunk;
			CURLcode res;

			chunk.memory = malloc(1);
			chunk.size = 0;

        if ((curl = curl_easy_init()) != NULL) {
				sprintf(str,"http://api.macvendors.com/%s",argV[1]);

                                curl_easy_setopt(curl, CURLOPT_URL, str);
				curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteMemoryCallback);
				curl_easy_setopt(curl, CURLOPT_WRITEDATA, (void *)&chunk);
				
				free(str);
				
				res = curl_easy_perform(curl);
				
                if (res == CURLE_OK) {
				checkResponse(chunk.memory);
                                return EXIT_SUCCESS;
                }
				
                curl_easy_cleanup(curl);
			}
		}

        return EXIT_FAILURE;
}
