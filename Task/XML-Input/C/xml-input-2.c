#include <gadget/gadget.h>

LIB_GADGET_START

Main
    Assert( Arg_count == 2, end_input );
    Get_arg_str( xml_file, 1 );
    Assert( Exist_file(xml_file), file_not_exist );

    char* xml = Load_string(xml_file);

    ST_GETTAG field = Unparser( &xml, "Students");
    Assert ( field.content, fail_content );

    while ( Occurs ("Student",field.content ) )
    {
        ST_GETTAG sub_field = Unparser( &field.content, "Student");

        if(sub_field.attrib)
        {
            int i=0;
            Iterator up i [ 0: 1: sub_field.len ]
            {
               if ( strcmp(sub_field.name[i], "Name" )==0 )
               {
                   Get_fn_let( sub_field.attrib[i], Str_tran( sub_field.attrib[i], "&#x00C9;","É" ) );
                   /* OK... I must write the function that change this diabolic characters :D */
                   Print "%s\n",sub_field.attrib[i];
                   break;
               }
            }
        }

        Free tag sub_field;
    }

    Free tag field;

  /* Exceptions areas */
    Exception( fail_content ){
       Msg_red("Not content for \"Students\" field\n");
    }
    Free secure xml;

    Exception( file_not_exist ){
       Msg_redf("File \"%s\" not found\n", xml_file);
    }
    Free secure xml_file;

    Exception( end_input ){
       Msg_yellow("Use:\n   RC_xml <xml_file.xml>");
    }

End
