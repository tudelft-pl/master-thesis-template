# Master Thesis

## Setup
Instructions to setup your system to compile this thesis.

1. Install the latest version of Python 2.x (version 2.6 or later). Python 3 is not supported.
2. Install the full TexLive distribution.
3. Install Pygments.

       sudo easy_install Pygments


## Subset of pages
To create a subset of pages (for review for example), install `stapler`.

The syntax is:

    stapler sel document.pdf 6-12 16 17-22 subset.pdf

