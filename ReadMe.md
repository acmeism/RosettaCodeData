RosettaCode Data Project
========================

This git repository contains (almost) all of the code samples available on
http://rosettacode.org organized by Language and Task.


## Getting the Data

All of the data is in this repository, so you can just run:

    git clone https://github.com/acmeism/RosettaCodeData

*However...*

It's a lot of data!

If you just want the latest data, the quickest thing to do is:

    git clone https://github.com/acmeism/RosettaCodeData --single-branch --depth=1


## Tools

This repository's data content is created by a Perl program called
`rosettacode`.

You can install it with this command:

    cpanm RosettaCode

You can rebuild the data with:

    make build


This repository has a `bin` directory with various tools for working with the
data.

* `rcd-api-list-all-langs`

    List all the programming language names directly from rosettacode.org

* `rcd-api-list-all-tasks`

    List all the programming task names directly from rosettacode.org

* `rcd-new-langs`

    List the RosettaCode languages not yet add to Conf

* `rcd-new-tasks`

    List the RosettaCode tasks not yet add to Conf

* `rcd-samples-per-lang`

    Show the number of code samples per language

* `rcd-samples-per-task`

    Show the number of code samples per task

* `rcd-tasks-per-lang`

    Show the number of tasks with code samples per language

* `rcd-langs-per-task`

    Show the number of languages with code samples per task


## To Do

Pull requests welcome!

This project is not a perfect representation of RosettaCode yet.
It has a few uncicode issues.
It also has to deal with various formatting mistakes in the mediawiki source
pages.

* Fix bugs

* Correct the 100s of guessed file extensions in `Conf/lang.yaml`

* Ability to only fetch cache pages since last pushed data update

* Support names with non-ascii characters

* Add more bin tools

* Address errors reported in rosettacode.log after running `make build`
