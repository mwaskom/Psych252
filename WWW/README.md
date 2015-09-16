Course Website
==============

This directory contains the source material and config file to build the course website. This is a [Sphinx](http://sphinx-doc.org/) website.

Raw datafiles go in `datasets/`. A description of the datasets lives in `data/index.rst`. The markup language used here is called RestructuredText, which is like Markdown but a bit more complex (and thus expressive).

PDFs of slides go in `WWW/slides_files`. IMPORTANT NOTE: This folder is *not* under version control (see .gitignore). 

Building the website
--------------------

To build the site, type `make html` in your terminal from this directory. Typing `make clean` first will remove old builds, which may be something you want to do.

Once you've built the site, if you want to check it before uploading, you'll have to start a local webserver. This is easy to do by running the following command in your terminal (from this directory):

    python -m SimpleHTTPServer

Once that is running, open a browser tab and navigate to `localhost:8000/_build/html`. This will show you the local version of the website.

Uploading to the Stanford website
---------------------------------

To upload the website, run the following command:

    ./upload_website.sh <sunetid>

where `<sunetid>` is replaced with your Stanford username. If your Stanford username is the same as the username on your computer, you can omit this argument. I believe that file permissions should persist in git, but if you get a "Permission denied" error, you have to make the script executable by doing `chmod u+x upload_website.sh`.
