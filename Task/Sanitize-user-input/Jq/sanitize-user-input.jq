def Person::new(firstName; lastName):
  {firstName: firstName,
   lastName: lastName };
	
def Person::tostring: .firstName + " " + .lastName;

def blacklist: [
    "drop", "delete", "erase", "kill", "wipe", "remove",
    "file", "files", "directory", "directories",
    "table", "tables", "record", "records", "database", "databases",
    "system", "system32", "system64", "rm", "rf", "rmdir", "format", "reformat"
];

def punct: "'-";            # allowable punctuation

def permissible:
  def ok: "[A-Za-z\(punct)]+";
  test("^" + ok +"$");

# Emit null or else the text of an error message
def checkInput:
  . as $name
  | (permissible and (((punct|contains($name[0:1])) or (punct|contains($name[-1:]))) | not)) as $ok
  | if $ok
    then
      if blacklist|index($name|ascii_downcase) then "Sorry, that name is unacceptable."
      else null
      end
    else "Sorry, that name contains unacceptable characters."
    end ;

# Attempt to obtain a valid response until "stop" or EOS.
# Set .invalid and .answer of the incoming object.
def ask:
  .invalid = false
  # Use `first(inputs)` to avoid error on EOS.
  | (first(inputs) // null) as $x
  | if $x | IN(null, "stop") then .answer = true # i.e. stop
    else .invalid = ($x|checkInput)
    | .answer = (if .invalid then null else $x end)
    end ;

# $max is the maximum number of full names to request (-1 for arbitrarily many)
def interact($max):

  # An array of Person
  def summary:
    "The following \(length) person(s) have been added to the database:",
    (.[] | Person::tostring);

  ["first", "last"] as $prompts
  | label $out
  # .question is the question number we are currently focused on.
  # .emit is the string to emit if it has been set.
  | foreach range(0; infinite) as $i (
      {question: 0, emit: null, array: []};

      if .array | length == $max
      then .finished = .array
      elif .emit then ask
      | if .answer == true then .finished = .array
        elif .invalid then .emit = .invalid + " Please re-enter:"
        else .emit = null
      | if   .question == 0
          then .first = .answer | .question = 1
          else .last  = .answer | .question = 0
          | .array = .array + [Person::new(.first; .last)]
          end
        end
      else .
      end
      # update .emit
      | if .finished then .emit = null
        elif .emit then .
        else .emit = "Enter your \($prompts[.question]) name : "
        end;

      if .finished then ., break $out
      elif .emit then .
      else empty
      end)
    | (select(.emit) | .emit),
      (select(.finished) | .array | summary) ;

interact(20)
