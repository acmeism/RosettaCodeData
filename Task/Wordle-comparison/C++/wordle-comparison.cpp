#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <string>
#include <vector>

enum Colour { GREEN, GREY, YELLOW };

const char NIL = '\0';

struct Two_Words {
   std::string answer;
   std::string guess;
};

std::string to_string(const Colour& colour) {
   std::string result;
   switch ( colour ) {
      case Colour::GREEN  : result = "Green";  break;
      case Colour::GREY   : result = "Grey";   break;
      case Colour::YELLOW : result = "Yellow"; break;
   }
   return result;
}

std::vector<Colour> wordle(const std::string& answer, const std::string& guess) {
   const uint32_t guess_length = guess.length();
   if ( answer.length() != guess_length ) {
      throw std::invalid_argument("The two words must have the same length.");
   }

   std::string answerCopy = answer;
   std::vector<Colour> result(guess_length, Colour::GREY);
   for ( uint32_t i = 0; i < guess_length; ++i ) {
      if ( answer[i] == guess[i] ) {
         answerCopy[i] = NIL;
         result[i] = Colour::GREEN;
      }
   }

   for ( uint32_t i = 0; i < guess_length; ++i ) {
      std::string::size_type index = answerCopy.find(guess[i]);
      if ( index != std::string::npos ) {
         answerCopy[index] = NIL;
         result[i] = Colour::YELLOW;
      }
   }
   return result;
}

int main() {
   const std::vector<Two_Words> pairs = { Two_Words("ALLOW", "LOLLY"), Two_Words("ROBIN", "SONIC"),
      Two_Words("CHANT", "LATTE"), Two_Words("We're", "She's"), Two_Words("NOMAD", "MAMMA") };

   for ( const Two_Words& pair : pairs ) {
      std::vector<Colour> colours = wordle(pair.answer, pair.guess);
      std::cout << pair.answer << " v " << pair.guess << " -> [";
      for ( uint32_t i = 0; i < pair.answer.length() - 1; ++i ) {
         std::cout << to_string(colours[i]) << ", ";
      }
      std::cout << to_string(colours.back()) << "]" << std::endl;
   }
}
