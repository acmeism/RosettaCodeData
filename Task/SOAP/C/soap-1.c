#include <curl/curl.h>
#include <string.h>
#include <stdio.h>

size_t write_data(void *ptr, size_t size, size_t nmeb, void *stream){
    return fwrite(ptr,size,nmeb,stream);
}

size_t read_data(void *ptr, size_t size, size_t nmeb, void *stream){
    return fread(ptr,size,nmeb,stream);
}

void callSOAP(char* URL, char * inFile, char * outFile) {

    FILE * rfp = fopen(inFile, "r");
    if(!rfp)
        perror("Read File Open:");

    FILE * wfp = fopen(outFile, "w+");
    if(!wfp)
        perror("Write File Open:");

    struct curl_slist *header = NULL;
		header = curl_slist_append (header, "Content-Type:text/xml");
		header = curl_slist_append (header, "SOAPAction: rsc");
		header = curl_slist_append (header, "Transfer-Encoding: chunked");
		header = curl_slist_append (header, "Expect:");
    CURL *curl;

    curl = curl_easy_init();
    if(curl) {
        curl_easy_setopt(curl, CURLOPT_URL, URL);
        curl_easy_setopt(curl, CURLOPT_POST, 1L);
        curl_easy_setopt(curl, CURLOPT_READFUNCTION, read_data);
        curl_easy_setopt(curl, CURLOPT_READDATA, rfp);
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_data);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, wfp);
        curl_easy_setopt(curl, CURLOPT_HTTPHEADER, header);
        curl_easy_setopt(curl, CURLOPT_POSTFIELDSIZE_LARGE, (curl_off_t)-1);
        curl_easy_setopt(curl, CURLOPT_VERBOSE,1L);
        curl_easy_perform(curl);

        curl_easy_cleanup(curl);
    }
}

int main(int argC,char* argV[])
{
	if(argC!=4)
		printf("Usage : %s <URL of WSDL> <Input file path> <Output File Path>",argV[0]);
	else
		callSOAP(argV[1],argV[2],argV[3]);
	return 0;
}
