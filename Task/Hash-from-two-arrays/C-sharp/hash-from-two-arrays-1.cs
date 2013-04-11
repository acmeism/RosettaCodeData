System.Collections.HashTable h = new System.Collections.HashTable();

string[] arg_keys = {"foo","bar","val"};
string[] arg_values = {"little", "miss", "muffet"};

//Some basic error checking
int arg_length = 0;
if ( arg_keys.Length == arg_values.Length ) {
  arg_length = arg_keys.Length;
}

for( int i = 0; i < arg_length; i++ ){
  h.add( arg_keys[i], arg_values[i] );
}
