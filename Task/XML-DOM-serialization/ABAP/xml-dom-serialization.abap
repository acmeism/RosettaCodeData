DATA: xml_string TYPE string.

DATA(xml)  = cl_ixml=>create( ).
DATA(doc)  = xml->create_document( ).
DATA(root) = doc->create_simple_element( name   = 'root'
                                         parent = doc ).

doc->create_simple_element( name   = 'element'
                            parent = root
                            value  = 'Some text here' ).

DATA(stream_factory) = xml->create_stream_factory( ).
DATA(stream)         = stream_factory->create_ostream_cstring( string = xml_string ).
DATA(renderer)       = xml->create_renderer( document = doc
                                             ostream  = stream ).
stream->set_pretty_print( abap_true ).
renderer->render( ).

cl_demo_output=>display_text( xml_string ).
