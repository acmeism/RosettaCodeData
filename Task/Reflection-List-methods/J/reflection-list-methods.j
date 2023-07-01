   NB. define a stack class
   coclass 'Stack'
   create =: 3 : 'items =: i. 0'
   push =: 3 : '# items =: items , < y'
   top =: 3 : '> {: items'
   pop =: 3 : ([;._2' a =. top 0; items =: }: items; a;')
   destroy =: codestroy
   cocurrent 'base'

   names_Stack_''      NB. all names
create  destroy pop     push    top

   'p' names_Stack_ 3  NB. verbs that start with p
pop  push


   NB. make an object.  The dyadic definition of cownew invokes the create verb
   S =: conew~ 'Stack'

   names__S''          NB. object specific names
COCREATOR items


   pop__S              NB. introspection: get the verbs definition
3 : 0
 a =. top 0
 items =: }: items
 a
)


   NB. get the search path of object S
   copath S
┌─────┬─┐
│Stack│z│
└─────┴─┘


   names__S 0         NB. get the object specific data
COCREATOR items
