#include <curl/curl.h>
#include <string.h>
#include <stdio.h>

#define from    "<sender@duniya.com>"
#define to      "<addressee@gmail.com>"
#define cc      "<info@example.org>"

static const char *payload_text[] = {
  "Date: Mon, 13 Jun 2018 11:30:00 +0100\r\n",
  "To: " to "\r\n",
  "From: " from " (Example User)\r\n",
  "Cc: " cc " (Another example User)\r\n",
  "Message-ID: <ecd7db36-10ab-437a-9g3a-e652b9458efd@"
  "rfcpedant.example.org>\r\n",
  "Subject: Sanding mail via C\r\n",
  "\r\n",
  "This mail is being sent by a C program.\r\n",
  "\r\n",
  "It connects to the GMail SMTP server, by far, the most popular mail program of all.\r\n",
  "Which is also probably written in C.\r\n",
  "To C or not to C..............\r\n",
  "That is the question.\r\n",
  NULL
};

struct upload_status {
  int lines_read;
};

static size_t payload_source(void *ptr, size_t size, size_t nmemb, void *userp)
{
  struct upload_status *upload_ctx = (struct upload_status *)userp;
  const char *data;

  if((size == 0) || (nmemb == 0) || ((size*nmemb) < 1)) {
    return 0;
  }

  data = payload_text[upload_ctx->lines_read];

  if(data) {
    size_t len = strlen(data);
    memcpy(ptr, data, len);
    upload_ctx->lines_read++;

    return len;
  }

  return 0;
}

int main(void)
{
  CURL *curl;
  CURLcode res = CURLE_OK;
  struct curl_slist *recipients = NULL;
  struct upload_status upload_ctx;

  upload_ctx.lines_read = 0;

  curl = curl_easy_init();
  if(curl) {

    curl_easy_setopt(curl, CURLOPT_USERNAME, "user");
    curl_easy_setopt(curl, CURLOPT_PASSWORD, "secret");

    curl_easy_setopt(curl, CURLOPT_URL, "smtp://smtp.gmail.com:465");

    curl_easy_setopt(curl, CURLOPT_USE_SSL, (long)CURLUSESSL_ALL);

    curl_easy_setopt(curl, CURLOPT_CAINFO, "/path/to/certificate.pem");

    curl_easy_setopt(curl, CURLOPT_MAIL_FROM, from);

    recipients = curl_slist_append(recipients, to);
    recipients = curl_slist_append(recipients, cc);
    curl_easy_setopt(curl, CURLOPT_MAIL_RCPT, recipients);

    curl_easy_setopt(curl, CURLOPT_READFUNCTION, payload_source);
    curl_easy_setopt(curl, CURLOPT_READDATA, &upload_ctx);
    curl_easy_setopt(curl, CURLOPT_UPLOAD, 1L);

    curl_easy_setopt(curl, CURLOPT_VERBOSE, 1L);

    res = curl_easy_perform(curl);

    if(res != CURLE_OK)
      fprintf(stderr, "curl_easy_perform() failed: %s\n",curl_easy_strerror(res));

    curl_slist_free_all(recipients);

    curl_easy_cleanup(curl);
  }

  return (int)res;
}
