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
