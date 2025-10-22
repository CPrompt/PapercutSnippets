# Custom Authentication for PaperCut

I used the example that was given here: https://github.com/PaperCutSoftware/CustomSynAndAuthentication/blob/main/pythonVersion/customUser.py

But I wanted to store the users in a database instead of just a dictonary.

I have tested this using:

Fedora 42
nginx
php
phpMyAdmin
MariaDB
python

There are a few python libraries that will be needed, such as bcrypt.

You will need to add your credentials for both the Python script as well as the config.php file in "usermanagement"

## Short explination on what to do

After you have the above installed and you are able to see the web pages for nginx and phpMyAdmin, we can then import the SQL file.  This simulates the PaperCut structure for users and groups.  

Once the database is loaded, you can configure the "custom_auth.py" Python script as Custom Authenticaiton.  Use this for reference:  https://www.papercut.com/help/manuals/ng-mf/common/synchronizing-and-authenticating-user-and-group-details-with-custom-programs-executables/

Make sure you add your custom token in PaperCut and reference it in the script.

You should be able to test the sychronization in PaperCut and it pull in the users from the database with the correct infomration.
If the synchronization works, you can log in as each of the users.  The given password for both users is just "password".

## Adding the User Edit
The next thing I wanted to do was to add a web page to add, edit, and delete users just like we would if we had Active Directory or such.

With nginx installed and configured, add the files for "usermanagement" to nginix which ever way your system is setup.  Some like to just drop it in /usr/shar/nginx/html/ while others use the sites-available.

Either way, you should be able to navigate to the directory and see the user management section.You can add, edit and delete users.  It is not styled so it is pretty generic looking.  However, you can make the changes and see them in PaperCut after synchronizing as well as inside MariaDB via phpMyAdmin.

This does use bcrpty to hash the passwords so that it has some level of encryption.

