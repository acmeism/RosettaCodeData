## RosettaCode Data Project

This Git Repository contains of all the code samples available on
http://rosettacode.org, along with instructions and supplemental tools to help
get them running on your local machine.

## Goals

The primary goal of this project is to get the code samples into the most
easily usable format, so that more programmers are exposed to them and actually
run them.

* Extract all (or most) of the code samples from RosettaCode.
* Give proper reference to their sources and authors.
* Provide automation for installing languages on common OSes.
* Provide automation for running the code samples. (Testing)

If the primary goals are successful, consider pushing code back to the wiki
from the Git repository. This could make it easier for people to contribute
content via Pull Requests and such.

## Implementation

The mirroring of RosettaCode.org is being performed by this program:

    https://github.com/ingydotnet/rosettacode-pm
    http://search.cpan.org/dist/RosettaCode

The tool accesses the RosettaCode wiki via the MediaWiki REST API, using the
CPAN module: [MediaWiki::Bot](https://metacpan.org/release/MediaWiki-Bot).

## License Info

This repository uses an Open Source tool (see above) to copy samples directly
from rosettacode.org. Each directory contains a link back to its
rosettacode.org source page. Please refer to rosettacode.org for the licensing
of all source code examples.

## Related Projects

[Andrew Cole](https://github.com/aocole?tab=repositories) is building an
interactive RosettaCodeExplorer web utility for playing around with the code
samples:

    https://github.com/aocole/RosettaCodeExplorer

## About the Author and Project

[Ingy döt Net](http://ingy.net) is an Acmeist (http://acmeism.org) hacker who
likes programming his ideas equivalently in multiple Open Source languages. His
works are available at https://github.com/ingydotnet/.

Ingy has been communicating with
[Mike Mol](http://rosettacode.org/wiki/User:Short_Circuit), the proprietor of
RosettaCode, regarding this project.
