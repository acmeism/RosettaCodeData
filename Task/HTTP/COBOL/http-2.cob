      *> manifest constants for libcurl
      *> Usage: COPY occurlsym  inside data division
      *>  Taken from include/curl/curl.h 2013-12-19

      *> Functional enums
       01 CURL_MAX_HTTP_HEADER CONSTANT AS     102400.

       78 CURL_GLOBAL_ALL                      VALUE 3.

       78 CURLOPT_FOLLOWLOCATION               VALUE 52.
       78 CURLOPT_WRITEDATA                    VALUE 10001.
       78 CURLOPT_URL                          VALUE 10002.
       78 CURLOPT_USERAGENT                    VALUE 10018.
       78 CURLOPT_WRITEFUNCTION                VALUE 20011.
       78 CURLOPT_COOKIEFILE                   VALUE 10031.
       78 CURLOPT_COOKIEJAR                    VALUE 10082.
       78 CURLOPT_COOKIELIST                   VALUE 10135.

      *> Informationals
       78 CURLINFO_COOKIELIST                  VALUE 4194332.

      *> Result codes
       78 CURLE_OK                             VALUE 0.
      *> Error codes
       78 CURLE_UNSUPPORTED_PROTOCOL           VALUE 1.
       78 CURLE_FAILED_INIT                    VALUE 2.
       78 CURLE_URL_MALFORMAT                  VALUE 3.
       78 CURLE_OBSOLETE4                      VALUE 4.
       78 CURLE_COULDNT_RESOLVE_PROXY          VALUE 5.
       78 CURLE_COULDNT_RESOLVE_HOST           VALUE 6.
       78 CURLE_COULDNT_CONNECT                VALUE 7.
       78 CURLE_FTP_WEIRD_SERVER_REPLY         VALUE 8.
       78 CURLE_REMOTE_ACCESS_DENIED           VALUE 9.
       78 CURLE_OBSOLETE10                     VALUE 10.
       78 CURLE_FTP_WEIRD_PASS_REPLY           VALUE 11.
       78 CURLE_OBSOLETE12                     VALUE 12.
       78 CURLE_FTP_WEIRD_PASV_REPLY           VALUE 13.
       78 CURLE_FTP_WEIRD_227_FORMAT           VALUE 14.
       78 CURLE_FTP_CANT_GET_HOST              VALUE 15.
       78 CURLE_OBSOLETE16                     VALUE 16.
       78 CURLE_FTP_COULDNT_SET_TYPE           VALUE 17.
       78 CURLE_PARTIAL_FILE                   VALUE 18.
       78 CURLE_FTP_COULDNT_RETR_FILE          VALUE 19.
       78 CURLE_OBSOLETE20                     VALUE 20.
       78 CURLE_QUOTE_ERROR                    VALUE 21.
       78 CURLE_HTTP_RETURNED_ERROR            VALUE 22.
       78 CURLE_WRITE_ERROR                    VALUE 23.
       78 CURLE_OBSOLETE24                     VALUE 24.
       78 CURLE_UPLOAD_FAILED                  VALUE 25.
       78 CURLE_READ_ERROR                     VALUE 26.
       78 CURLE_OUT_OF_MEMORY                  VALUE 27.
       78 CURLE_OPERATION_TIMEDOUT             VALUE 28.
       78 CURLE_OBSOLETE29                     VALUE 29.
       78 CURLE_FTP_PORT_FAILED                VALUE 30.
       78 CURLE_FTP_COULDNT_USE_REST           VALUE 31.
       78 CURLE_OBSOLETE32                     VALUE 32.
       78 CURLE_RANGE_ERROR                    VALUE 33.
       78 CURLE_HTTP_POST_ERROR                VALUE 34.
       78 CURLE_SSL_CONNECT_ERROR              VALUE 35.
       78 CURLE_BAD_DOWNLOAD_RESUME            VALUE 36.
       78 CURLE_FILE_COULDNT_READ_FILE         VALUE 37.
       78 CURLE_LDAP_CANNOT_BIND               VALUE 38.
       78 CURLE_LDAP_SEARCH_FAILED             VALUE 39.
       78 CURLE_OBSOLETE40                     VALUE 40.
       78 CURLE_FUNCTION_NOT_FOUND             VALUE 41.
       78 CURLE_ABORTED_BY_CALLBACK            VALUE 42.
       78 CURLE_BAD_FUNCTION_ARGUMENT          VALUE 43.
       78 CURLE_OBSOLETE44                     VALUE 44.
       78 CURLE_INTERFACE_FAILED               VALUE 45.
       78 CURLE_OBSOLETE46                     VALUE 46.
       78 CURLE_TOO_MANY_REDIRECTS             VALUE 47.
       78 CURLE_UNKNOWN_TELNET_OPTION          VALUE 48.
       78 CURLE_TELNET_OPTION_SYNTAX           VALUE 49.
       78 CURLE_OBSOLETE50                     VALUE 50.
       78 CURLE_PEER_FAILED_VERIFICATION       VALUE 51.
       78 CURLE_GOT_NOTHING                    VALUE 52.
       78 CURLE_SSL_ENGINE_NOTFOUND            VALUE 53.
       78 CURLE_SSL_ENGINE_SETFAILED           VALUE 54.
       78 CURLE_SEND_ERROR                     VALUE 55.
       78 CURLE_RECV_ERROR                     VALUE 56.
       78 CURLE_OBSOLETE57                     VALUE 57.
       78 CURLE_SSL_CERTPROBLEM                VALUE 58.
       78 CURLE_SSL_CIPHER                     VALUE 59.
       78 CURLE_SSL_CACERT                     VALUE 60.
       78 CURLE_BAD_CONTENT_ENCODING           VALUE 61.
       78 CURLE_LDAP_INVALID_URL               VALUE 62.
       78 CURLE_FILESIZE_EXCEEDED              VALUE 63.
       78 CURLE_USE_SSL_FAILED                 VALUE 64.
       78 CURLE_SEND_FAIL_REWIND               VALUE 65.
       78 CURLE_SSL_ENGINE_INITFAILED          VALUE 66.
       78 CURLE_LOGIN_DENIED                   VALUE 67.
       78 CURLE_TFTP_NOTFOUND                  VALUE 68.
       78 CURLE_TFTP_PERM                      VALUE 69.
       78 CURLE_REMOTE_DISK_FULL               VALUE 70.
       78 CURLE_TFTP_ILLEGAL                   VALUE 71.
       78 CURLE_TFTP_UNKNOWNID                 VALUE 72.
       78 CURLE_REMOTE_FILE_EXISTS             VALUE 73.
       78 CURLE_TFTP_NOSUCHUSER                VALUE 74.
       78 CURLE_CONV_FAILED                    VALUE 75.
       78 CURLE_CONV_REQD                      VALUE 76.
       78 CURLE_SSL_CACERT_BADFILE             VALUE 77.
       78 CURLE_REMOTE_FILE_NOT_FOUND          VALUE 78.
       78 CURLE_SSH                            VALUE 79.
       78 CURLE_SSL_SHUTDOWN_FAILED            VALUE 80.
       78 CURLE_AGAIN                          VALUE 81.

      *> Error strings
       01 LIBCURL_ERRORS.
          02 CURLEVALUES.
             03 FILLER PIC X(30) VALUE "CURLE_UNSUPPORTED_PROTOCOL    ".
             03 FILLER PIC X(30) VALUE "CURLE_FAILED_INIT             ".
             03 FILLER PIC X(30) VALUE "CURLE_URL_MALFORMAT           ".
             03 FILLER PIC X(30) VALUE "CURLE_OBSOLETE4               ".
             03 FILLER PIC X(30) VALUE "CURLE_COULDNT_RESOLVE_PROXY   ".
             03 FILLER PIC X(30) VALUE "CURLE_COULDNT_RESOLVE_HOST    ".
             03 FILLER PIC X(30) VALUE "CURLE_COULDNT_CONNECT         ".
             03 FILLER PIC X(30) VALUE "CURLE_FTP_WEIRD_SERVER_REPLY  ".
             03 FILLER PIC X(30) VALUE "CURLE_REMOTE_ACCESS_DENIED    ".
             03 FILLER PIC X(30) VALUE "CURLE_OBSOLETE10              ".
             03 FILLER PIC X(30) VALUE "CURLE_FTP_WEIRD_PASS_REPLY    ".
             03 FILLER PIC X(30) VALUE "CURLE_OBSOLETE12              ".
             03 FILLER PIC X(30) VALUE "CURLE_FTP_WEIRD_PASV_REPLY    ".
             03 FILLER PIC X(30) VALUE "CURLE_FTP_WEIRD_227_FORMAT    ".
             03 FILLER PIC X(30) VALUE "CURLE_FTP_CANT_GET_HOST       ".
             03 FILLER PIC X(30) VALUE "CURLE_OBSOLETE16              ".
             03 FILLER PIC X(30) VALUE "CURLE_FTP_COULDNT_SET_TYPE    ".
             03 FILLER PIC X(30) VALUE "CURLE_PARTIAL_FILE            ".
             03 FILLER PIC X(30) VALUE "CURLE_FTP_COULDNT_RETR_FILE   ".
             03 FILLER PIC X(30) VALUE "CURLE_OBSOLETE20              ".
             03 FILLER PIC X(30) VALUE "CURLE_QUOTE_ERROR             ".
             03 FILLER PIC X(30) VALUE "CURLE_HTTP_RETURNED_ERROR     ".
             03 FILLER PIC X(30) VALUE "CURLE_WRITE_ERROR             ".
             03 FILLER PIC X(30) VALUE "CURLE_OBSOLETE24              ".
             03 FILLER PIC X(30) VALUE "CURLE_UPLOAD_FAILED           ".
             03 FILLER PIC X(30) VALUE "CURLE_READ_ERROR              ".
             03 FILLER PIC X(30) VALUE "CURLE_OUT_OF_MEMORY           ".
             03 FILLER PIC X(30) VALUE "CURLE_OPERATION_TIMEDOUT      ".
             03 FILLER PIC X(30) VALUE "CURLE_OBSOLETE29              ".
             03 FILLER PIC X(30) VALUE "CURLE_FTP_PORT_FAILED         ".
             03 FILLER PIC X(30) VALUE "CURLE_FTP_COULDNT_USE_REST    ".
             03 FILLER PIC X(30) VALUE "CURLE_OBSOLETE32              ".
             03 FILLER PIC X(30) VALUE "CURLE_RANGE_ERROR             ".
             03 FILLER PIC X(30) VALUE "CURLE_HTTP_POST_ERROR         ".
             03 FILLER PIC X(30) VALUE "CURLE_SSL_CONNECT_ERROR       ".
             03 FILLER PIC X(30) VALUE "CURLE_BAD_DOWNLOAD_RESUME     ".
             03 FILLER PIC X(30) VALUE "CURLE_FILE_COULDNT_READ_FILE  ".
             03 FILLER PIC X(30) VALUE "CURLE_LDAP_CANNOT_BIND        ".
             03 FILLER PIC X(30) VALUE "CURLE_LDAP_SEARCH_FAILED      ".
             03 FILLER PIC X(30) VALUE "CURLE_OBSOLETE40              ".
             03 FILLER PIC X(30) VALUE "CURLE_FUNCTION_NOT_FOUND      ".
             03 FILLER PIC X(30) VALUE "CURLE_ABORTED_BY_CALLBACK     ".
             03 FILLER PIC X(30) VALUE "CURLE_BAD_FUNCTION_ARGUMENT   ".
             03 FILLER PIC X(30) VALUE "CURLE_OBSOLETE44              ".
             03 FILLER PIC X(30) VALUE "CURLE_INTERFACE_FAILED        ".
             03 FILLER PIC X(30) VALUE "CURLE_OBSOLETE46              ".
             03 FILLER PIC X(30) VALUE "CURLE_TOO_MANY_REDIRECTS      ".
             03 FILLER PIC X(30) VALUE "CURLE_UNKNOWN_TELNET_OPTION   ".
             03 FILLER PIC X(30) VALUE "CURLE_TELNET_OPTION_SYNTAX    ".
             03 FILLER PIC X(30) VALUE "CURLE_OBSOLETE50              ".
             03 FILLER PIC X(30) VALUE "CURLE_PEER_FAILED_VERIFICATION".
             03 FILLER PIC X(30) VALUE "CURLE_GOT_NOTHING             ".
             03 FILLER PIC X(30) VALUE "CURLE_SSL_ENGINE_NOTFOUND     ".
             03 FILLER PIC X(30) VALUE "CURLE_SSL_ENGINE_SETFAILED    ".
             03 FILLER PIC X(30) VALUE "CURLE_SEND_ERROR              ".
             03 FILLER PIC X(30) VALUE "CURLE_RECV_ERROR              ".
             03 FILLER PIC X(30) VALUE "CURLE_OBSOLETE57              ".
             03 FILLER PIC X(30) VALUE "CURLE_SSL_CERTPROBLEM         ".
             03 FILLER PIC X(30) VALUE "CURLE_SSL_CIPHER              ".
             03 FILLER PIC X(30) VALUE "CURLE_SSL_CACERT              ".
             03 FILLER PIC X(30) VALUE "CURLE_BAD_CONTENT_ENCODING    ".
             03 FILLER PIC X(30) VALUE "CURLE_LDAP_INVALID_URL        ".
             03 FILLER PIC X(30) VALUE "CURLE_FILESIZE_EXCEEDED       ".
             03 FILLER PIC X(30) VALUE "CURLE_USE_SSL_FAILED          ".
             03 FILLER PIC X(30) VALUE "CURLE_SEND_FAIL_REWIND        ".
             03 FILLER PIC X(30) VALUE "CURLE_SSL_ENGINE_INITFAILED   ".
             03 FILLER PIC X(30) VALUE "CURLE_LOGIN_DENIED            ".
             03 FILLER PIC X(30) VALUE "CURLE_TFTP_NOTFOUND           ".
             03 FILLER PIC X(30) VALUE "CURLE_TFTP_PERM               ".
             03 FILLER PIC X(30) VALUE "CURLE_REMOTE_DISK_FULL        ".
             03 FILLER PIC X(30) VALUE "CURLE_TFTP_ILLEGAL            ".
             03 FILLER PIC X(30) VALUE "CURLE_TFTP_UNKNOWNID          ".
             03 FILLER PIC X(30) VALUE "CURLE_REMOTE_FILE_EXISTS      ".
             03 FILLER PIC X(30) VALUE "CURLE_TFTP_NOSUCHUSER         ".
             03 FILLER PIC X(30) VALUE "CURLE_CONV_FAILED             ".
             03 FILLER PIC X(30) VALUE "CURLE_CONV_REQD               ".
             03 FILLER PIC X(30) VALUE "CURLE_SSL_CACERT_BADFILE      ".
             03 FILLER PIC X(30) VALUE "CURLE_REMOTE_FILE_NOT_FOUND   ".
             03 FILLER PIC X(30) VALUE "CURLE_SSH                     ".
             03 FILLER PIC X(30) VALUE "CURLE_SSL_SHUTDOWN_FAILED     ".
             03 FILLER PIC X(30) VALUE "CURLE_AGAIN                   ".
       01 FILLER REDEFINES LIBCURL_ERRORS.
          02 CURLEMSG OCCURS 81 TIMES PIC X(30).
