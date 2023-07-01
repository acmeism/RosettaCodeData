report z_http.

cl_http_client=>create_by_url(
  exporting
    url                = `http://rosettacode.org/robots.txt`
  importing
    client             = data(http_client)
  exceptions
    argument_not_found = 1
    plugin_not_active  = 2
    internal_error     = 3
    others             = 4 ).

if sy-subrc <> 0.
  data(error_message) = switch string( sy-subrc
    when 1 then `argument_not_found`
    when 2 then `plugin_not_active`
    when 3 then `internal_error`
    when 4 then `other error` ).

  write error_message.
  exit.
endif.

data(rest_http_client) = cast if_rest_client( new cl_rest_http_client( http_client ) ).

rest_http_client->get( ).

data(response_string) = rest_http_client->get_response_entity( )->get_string_data( ).

split response_string at cl_abap_char_utilities=>newline into table data(output_table).

loop at output_table assigning field-symbol(<output_line>).
  write / <output_line>.
endloop.
