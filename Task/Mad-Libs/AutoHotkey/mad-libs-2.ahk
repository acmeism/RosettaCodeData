#include <iostream>
#include <string>
using namespace std;

int main()
{
  string story, input;

  //Loop
  while(true)
  {
    //Get a line from the user
    getline(cin, input);

    //If it's blank, break this loop
    if(input == "\r")
      break;

    //Add the line to the story
    story += input;
  }

  //While there is a '<' in the story
  int begin;
  while((begin = story.find("<")) != string::npos)
  {
    //Get the category from between '<' and '>'
    int end = story.find(">");
    string cat = story.substr(begin + 1, end - begin - 1);

    //Ask the user for a replacement
    cout << "Give me a " << cat << ": ";
    cin >> input;

    //While there's a matching category
    //in the story
    while((begin = story.find("<" + cat + ">")) != string::npos)
    {
      //Replace it with the user's replacement
      story.replace(begin, cat.length()+2, input);
    }
  }

  //Output the final story
  cout << endl << story;

  return 0;
}
