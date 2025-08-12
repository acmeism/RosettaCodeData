try {
   std::string input = get_input();
   if (input.empty() )
       throw const std::string{"no input received");
   // process input ...

   if ( result == -1) throw BAD_VALUE;

}
catch (const std::string &s) {
    std::cerr << "ERROR:\t" << s << "\n";
}
catch (const int &e) {
    std::cerr << "ERROR:\t" << err_to_string(e) << "\n";
}
