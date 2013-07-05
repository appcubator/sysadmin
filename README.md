Appcubator-sysadmin
===================

1. Configures nginx sites
2. Configures uwsgi upstart scripts

Allows you to do:

  sudo service [ nginx | uwsgi-site | uwsgi-deploy | uwsgi-hosting ] \
      [ start | stop | restart | reload ]


Usage
=====

    sudo APPCUBATOR_MODE=staging python setup_stuff.py

Then do the following:

    sudo chgrp www-data logs
    sudo chgrp www-data sockets
    sudo chgrp www-data pidfiles
    sudo chmod g+rwx logs
    sudo chmod g+rwx sockets
    sudo chmod g+rwx pidfiles
