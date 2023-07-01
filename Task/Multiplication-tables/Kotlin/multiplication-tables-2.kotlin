{def format
 {lambda {:w :c}
  {@ style="width::wpx;
            color::c;
            text-align:right;"
}}}
-> format

{def operation
 {lambda {:op :i :j}
  {if {and {= :i 0} {= :j 0}}                    // left top cell
   then {format 30 #fff}                         // is empty
   else {if {= :i 0}                             // top row
   then {format 30 #ff0}:j                       // is yellow
   else {if {= :j 0}                             // left col
   then {format 30 #0ff}:i                       // is cyan
   else {format 30 #ccc}                         // is lightgrey
        {if {<= :i :j} then {:op :i :j} else .}  // cell [i,j]
}}}}}
-> operation

{def make_table
 {lambda {:func :row :col}
  {table {@ style="box-shadow:0 0 8px #000;"}
   {S.map                                   // apply
    {{lambda {:func :col :j}                // function row
     {tr {S.map                             // apply
      {{lambda {:func :i :j}                // function cell
       {td {:func :i :j}}} :func :j}        // apply func on [i,j]
        {S.serie 0 :col}}}} :func :col}     // from 0 to col
         {S.serie 0 :row}                   // from 0 to row
}}}}
-> make_table

The following calls:

1) {make_table {operation +} 5 15}
2) {make_table {operation *} 12 12}
3) {make_table {operation pow} 6 10}
