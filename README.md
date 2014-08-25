web2py-migrate
==============

Easy [web2py](https://github.com/web2py/web2py/) database migration scaffolding for continuous integration
or simple version control.

This project aim is organize and control [web2py](https://github.com/web2py/web2py/) database migrate
with version control using version control tags.

So you can assign your versions with tags for some branchs. For example, if you have a dev and a master branch
you can assign `master-migrate` and `dev-migrate` tags and your migrates for dev and master databases will be
independently controlled.

This is very important if you want a [Continuous Integration](http://en.wikipedia.org/wiki/Continuous_integration)
like environment.

How to Use
--------------

Opening `env_vars.sh` file you will see some configurations for:

* version control (just git by now, but easily extensible to mercurial and others)
    * VERSION_CONTROL_TYPE (just git by now or dummy for testing)
    * TAG (your tag for version control... you can use more then one tag for various branchs migrations)
    * BRANCH (your current branch, some CI platforms have this variable for you)

* database (just postgres and mysql by now, but easily extensible too)
    * DB_TYPE (just postgres or mysql by now)
    * RDS_HOSTNAME (your hostname for database)
    * RDS_USERNAME (your username for database)
    * RDS_PASSWORD (your password for database)
    * RDS_DB_NAME (your database name)
    * RDS_PORT (port for your database connection)

* web2py
    * WEB2PY (path for your web2py) NEED TO BE INSIDE YOUR VERSION CONTROL STRUCTURE
    * APP (your web2py application name)

Opening `Makefile` you will see a commented line:

`include env_vars.sh`

Uncomment this line if you want to import env_vars using Makefile. If these variables are already
in your environment you don't need to uncomment. 

Setting these configurations you are ready to use web2py-migrate!

Now just use make command:

`make`

Now your first database migration is working and the TAG is now on your version control!

If some errors occur, database will be backed up but tags are NOT RESTRUCTURED!!

For Developers
---------------

There are dummy files inside folders `version_control` and `databases`.

These dummy files are useful if you want to extend this project because all of needed functions are there to implement
new database or version control support.
 
