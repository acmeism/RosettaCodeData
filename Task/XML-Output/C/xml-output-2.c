#include <gadget/gadget.h>

LIB_GADGET_START

const char* codes[] = {"&amp;","&gt;","&lt;"};
const char* repl[]  = {"&",">","<"};

char* change_codes( const char* xml_line )
{
    int i;
    String xml;
    Let( xml, xml_line );
    Iterator up i [0:1:3]{
        Get_fn_let( xml, Str_tran( xml, repl[i], codes[i] ) );
    }
    return xml;
}
char* generate_xml( const char* names[], int lnames, const char* remarks[] )
{
    String xml;
    char attrib[100];
    int i;
    Iterator up i [0:1:lnames]{
        String remk;
        Get_fn_let ( remk,  change_codes( remarks[i] ) );
        sprintf(attrib,"name=\"%s\"",names[i]);
        if(!i) {
            Get_fn_let ( xml, Parser("Character", attrib, remk, NORMAL_TAG ));
        }else{
            Get_fn_cat ( xml, Parser("Character", attrib, remk, NORMAL_TAG ));
        }
        Free secure remk;
    }
    Get_fn_let ( xml, Parser("CharacterRemarks", "", xml, NORMAL_TAG ));
    Get_fn_let ( xml, Str_tran(xml,"><",">\n<") );

    return xml;
}

#define alen(_X_)   ( sizeof(_X_) / sizeof(const char*) )
Main
   const char *names[] = {
       "April", "Tam O'Shanter", "Emily"
   };
   const char *remarks[] = {
       "Bubbly: I'm > Tam and <= Emily",
       "Burns: \"When chapman billies leave the street ...\"",
       "Short & shrift"
   };
   char* xml = generate_xml( names, alen(names), remarks );
   Print "%s\n", xml;
   Free secure xml;
End
