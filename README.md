web2py-migrate
==============

Easy [web2py](https://github.com/web2py/web2py/) database migration workflow and scaffolding for continuous integration
or simple version control.

This project aim is organize and control [web2py](https://github.com/web2py/web2py/) database migrate
with version control using version control tags.

So you can assign your versions with tags for some branchs. For example, if you have a dev and a master branch
you can assign `master-migrate` and `develop-migrate` tags and your migrates for dev and master databases will be
independently controlled.

This is very important if you want a [Continuous Integration](http://en.wikipedia.org/wiki/Continuous_integration)
like environment.

How it works
--------------
![Image of Workflow](http://www.gliffy.com/go/publish/image/6093083/L.png)

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

If you want more, you can do these tricks:
* Add to sql foder before migrates sql for eg. prepopulate some table
* Add to sql folder after migrates sql for eg. data migration
* Add python scripts inside migrate.py to run some command after migration using your web2py app model

`sql` folder need scripts using names: `before-BRANCH.sql` and `after-BRANCH.sql` like examples inside folder that use develop and master branchs.

Now your first database migration is working and the TAG is now on your version control!

If some errors occur, database will be backed up but tags are NOT RESTRUCTURED and before and after migration scripts are NOT CLEANED!!

For Developers
---------------

There are dummy files inside folders `version_control` and `databases`.

These dummy files are useful if you want to extend this project because all of needed functions are there to implement new database or version control support.

Implement support for a Version Control
---------------
---------------
* Go to `version_control` folder
* Copy dummy file
* implement necessary bash functions:
   * `vc_check_tag()`: function that return exit 0 if tag exists or error if not;
   * `vc_go_to_tag()`: function that change your code version to tag version;
   * `vc_status()`: function that show status of version control (just for logging);
   * `vc_back_to_branch()`: function that back to your current version of code;
   * `vc_remove_tag()`: function that remove tag from your version control;
   * `vc_add_tag()`: function that add tag on your current version code;
   * `vc_send()`: function that send new code version to your version control;
* Finish! Now we should support your version control
 
Implement support for a Database
---------------
---------------
* Go to `databases` folder
* Copy dummy file
* implement necessary bash functions:
   * `rds_import()`: function that can execute commands from a file into your database;
   * `rds_backup()`: function that backup your current database (can be a copy or a dump or what you want);
   * `rds_restore()`: function that restore your current database (if migrate fails);
   * `rds_finish()`: function that clean your database or test server (eg. remove dumps or delete database copy, etc);
* Finish! Now we should support your database

Final Remarks
---------------
---------------

You can implement any other extra function that you need, but those are really necessary.

Any questions please send me a message.

Enjoy ;)
