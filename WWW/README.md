Course Website
==============

This directory contains the source material and config file to build the course website. This is a [Sphinx](http://sphinx-doc.org/) website.

To build the site, type `make html`. Typing `make clean` first will remove old builds, which may be something you want to do. To upload the built site to the Stanford webspace, type `make upload`. (These stages can be combined; i.e. `make clean html upload`.

Raw datafiles go in `datasets/`. A description of the datasets lives in `data/datasets.rst`. The markup language used here is called RestructuredText, which is like Markdown but a bit more complex (and thus expressive).

For steph: make -f Makefile_steph clean html upload