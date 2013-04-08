## RosettaCode GitHub Mirror

This Git Repository will eventually be a mirror of all the code samples
available on http://rosettacode.org, along with instructions and supplemental
tools to help get them running on your local machine.

## Goals

The primary goal here is to get the codes into the most easily usable format,
so that more programmers are exposed to them and actually run them.

* Extract all (or most) of the code samples from RosettaCode.
* Give proper reference to their sources and authors.
* Provide automation for installing languages on common OSes.
* Provide automation for running the code samples. (Testing)

If the primary goals are successful, consider pushing code back to the wiki
from the Git repository. This could make it easier for people to contribute
content via Pull Requests and such.

## Implementation

The mirroring of RosettaCode.org is being perform by a program whose repository
is here:

    https://github.com/ingydotnet/rosettacode-pm
    http://search.cpan.org/dist/RosettaCode

The tool accesses the RosettaCode wiki via the MediaWiki REST API, using the
CPAN module: MediaWiki::Bot.

## About the Author and Project

Ingy döt Net is an Acmeist (http://acmeism.org) hacker who likes programming
his ideas equivalently in multiple Open Source languages. His works are
available at https://github.com/ingydotnet/.

Ingy has been communicating with Mike Mol, the proprietor of RosettaCode,
regarding this mirroring attempt.
