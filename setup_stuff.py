#! /usr/bin/python
"""
1. Configures nginx sites
2. Configures uwsgi upstart scripts

Allows you to do:

  sudo service
    [ nginx | uwsgi-site | uwsgi-deploy ]
      [ start | stop | restart | reload ]

"""


import os
import os.path
from os.path import join as j
import sys
import subprocess
import shlex


this_dir = os.path.abspath(os.path.dirname(__file__))
nginx_dir = '/etc/nginx/sites-enabled'
upstart_dir = "/etc/init"

try:
    staging = os.environ['APPCUBATOR_MODE']
    assert staging in ['prod', 'staging']
except (KeyError, AssertionError):
    print >> sys.stderr, "export APPCUBATOR_MODE to staging or prod"
    sys.exit(1)


def run_command(command):
    shell_splitted_command = shlex.split(command)
    p = subprocess.Popen(shell_splitted_command, stdout=sys.stdout, stderr=sys.stderr)
    p.wait()
    return p.returncode

def symlink(src, dest, *args, **kwargs):
    if os.path.exists(dest):
        print >> sys.stderr, "About to link %s to %s, overwriting %s, proceed? [y/n]:" % (dest, src, dest)
        ch = raw_input()
        if ch.lower().startswith('y'):
            os.remove(dest)
        else:
            return

    os.symlink(src, dest, *args, **kwargs)

def deploy_upstart(ini_path, desc, command_name):
    site_upstart_template = open(j(this_dir, 'upstart.conf.template'), "r").read()
    site_upstart = site_upstart_template.format(UWSGI_INI_LOCATION=ini_path,
                                                UWSGI_FOR=desc)

    with open(j(upstart_dir, '%s.conf' % command_name), "w") as upstart_dest:
        upstart_dest.write(site_upstart)

# site
print "Setting up site nginx and uwsgi"
symlink(j(this_dir, 'site', 'nginx-%s.conf' % staging), j(nginx_dir, 'site-nginx-%s.conf' % staging))
deploy_upstart(j(this_dir, 'site', 'uwsgi-%s.ini' % staging), 'appcubator-site', 'uwsgi-site')

# deployment
print "Setting up deployment nginx and uwsgi"
symlink(j(this_dir, 'deploy', 'nginx-%s.conf' % staging), j(nginx_dir, 'deploy-nginx-%s.conf' % staging))
deploy_upstart(j(this_dir, 'deploy', 'uwsgi-deploy-%s.ini' % staging), 'appcubator-deploy', 'uwsgi-deploy.conf')

# deployment celery
print "Setting up celeryd init and config files"
print "  (this sets up celery but you may still have to set up rabbitmq)"
symlink(j(this_dir, 'deploy', 'celeryd-defaults-%s.conf' % staging), '/etc/default/celeryd')
symlink(j(this_dir, 'deploy', 'celeryd-init.conf'), '/etc/init.d/celeryd')

# hosting
print "Setting up hosting uwsgi"
deploy_upstart(j(this_dir, 'deploy', 'uwsgi-emperor.ini'), 'appcubator hosting', 'uwsgi-hosting')

run_command('initctl reload-configuration')
