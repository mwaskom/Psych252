Course Website
==============

This directory contains the source material and config file to build the course website. This is a [Sphinx](http://sphinx-doc.org/) website.

To build the site, type `make html`. Typing `make clean` first will remove old builds, which may be something you want to do.

Raw datafiles go in `datasets/`. A description of the datasets lives in `data/datasets.rst`. The markup language used here is called RestructuredText, which is like Markdown but a bit more complex (and thus expressive).

Uploading to the Stanford website
---------------------------------

To upload the website, run the following command:

    ./upload_website.sh <sunetid>

where `<sunetid>` is replaced with your Stanford username. If your Stanford username is the same as the username on your computer, you can omit this argument. I believe that file permissions should persist in git, but if you get a "Permission denied" error, you have to make the script executable by doing `chmod u+x upload_website.sh`.
