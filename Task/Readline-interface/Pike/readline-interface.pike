#!/usr/bin/pike

inherit "watch.pike";

Stdio.Readline readln = Stdio.Readline();

void print_help()
{
    write("The following commands are available: \n");
    write(sort(indices(functions))*", ");
    write("\n");
}

void watch_add()
{
    ::watch_add(db);
}

void watch_list()
{
    ::watch_list(db);
}

void do_exit()
{
    exit(0);
}

mapping functions = ([ "add":watch_add,
                       "list":watch_list,
                       "load":watch_load,
                       "save":watch_save,
                       "help":print_help,
                       "quit":do_exit ]);

string prompt_read(string prompt)
{
    return readln->read(prompt+": ");
}

void main()
{
  Stdio.Readline.History readline_history = Stdio.Readline.History(512);
  readln->enable_history(readline_history);

  string prompt="> ";


  print_help();
  while(1)
  {
    string input=readln->read(prompt);
    if(!input)
      exit(0);
    if(input != "")
    {
       if (functions[input])
           functions[input]();
       else
       {
           write("unknown command\n");
           print_help();
       }
    }
  }
}
