use strict;
use warnings;
use JSON;

# Sample JSON document
my $json_text = '{
  "wiki": {
    "links": [
      "https://rosettacode.org/wiki/Rosetta_Code",
      "https://discord.com/channels/1011262808001880065"
    ]
  },
  "": "Rosetta",
  " ": "Code",
  "g/h": "chrestomathy",
  "i~j": "site",
  "abc": ["is", "a"],
  "def": { "": "programming" }
}';

# Decode the JSON document
my $document = decode_json($json_text);

# Sample JSON Pointers with expected result
my @pointers = (
    "",               # Entire document
    "/",              # "Rosetta"
    "/ ",             # "Code"
    "/abc",           # ["is", "a"]
    "/def/",          # "programming"
    "/g~1h",          # "chrestomathy"
    "/i~0j",          # "site"
    "/wiki/links/0",  # "https://rosettacode.org/wiki/Rosetta_Code"
    "/wiki/links/1",  # "https://discord.com/channels/1011262808001880065"
    "/wiki/links/2",  # Error condition
    "/wiki/name",     # Error condition
    "/no/such/thing", # Error condition
    "bad/pointer"     # Error condition
);

# Function to evaluate a JSON Pointer
sub evaluate_pointer {
    my ($document, $pointer) = @_;

    # An empty pointer means the whole document
    return $document if($pointer eq '');

    # check for valid pointer starting with forward slash
    return "Error: Non-empty JSON pointers must begin with /" if($pointer !~ /^\//);

    # Initialize the current node to the document root
    my $current_node = $document;

    # Split the pointer into tokens
    my @tokens = split '/', $pointer;

    if(scalar @tokens < 1) {
       # Empty token should be a key in the hash
       if (exists $current_node->{''}) {
           $current_node = $current_node->{''};
       } else {
           return "Error: Key '' (empty token) not found.";
       }
    }

    # Process each token
    for my $token (@tokens) {
        next if($token eq '');  # Skip the empty token from the leading slash

        # Decode the token
        $token =~ s/~1/\//g;
        $token =~ s/~0/~/g;

        # Check the current node type
        if (ref($current_node) eq 'ARRAY') {
            # Token should be an array index
            if ($token =~ /^\d+$/ && $token < @$current_node) {
                $current_node = $current_node->[$token];
            } else {
                return "Error: Invalid array index or out of range.";
            }
        } elsif (ref($current_node) eq 'HASH') {
            # Token should be a key in the hash
            if (exists $current_node->{$token}) {
                $current_node = $current_node->{$token};
            } else {
                return "Error: Key '$token' not found.";
            }
        } else {
            return "Error: Current node is not an array or object.";
        }
    }

    return $current_node;
}

# Evaluate each pointer and print the result
foreach my $pointer (@pointers) {
    my $result = evaluate_pointer($document, $pointer);
    print "Pointer: \"$pointer\"\n";
    if (ref($result) eq 'HASH' || ref($result) eq 'ARRAY') {
        print "Result: " . encode_json($result) . "\n";
    } else {
        print "Result: $result\n";
    }
    print "\n";
}

