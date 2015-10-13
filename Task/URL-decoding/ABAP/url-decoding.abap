REPORT Z_DECODE_URL.

DATA: lv_encoded_url TYPE string VALUE 'http%3A%2F%2Ffoo%20bar%2F',
      lv_decoded_url TYPE string.

CALL METHOD CL_HTTP_UTILITY=>UNESCAPE_URL
  EXPORTING
    ESCAPED   = lv_encoded_url
  RECEIVING
    UNESCAPED = lv_decoded_url.

WRITE: 'Encoded URL: ', lv_encoded_url, /, 'Decoded URL: ', lv_decoded_url.
