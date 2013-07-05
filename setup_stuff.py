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


this_dir = os.path.abspath(os.path.dirname(__FILE__))
nginx_dir = '/etc/nginx/sites-enabled'
upstart_dir = "/etc/init"

staging = os.environ['APPCUBATOR_MODE']
assert staging in ['prod', 'staging'], "export APPCUBATOR_MODE to staging or prod"


def run_command(command):
    shell_splitted_command = shlex.split(command)
    p = subprocess.Popen(shell_splitted_command, stdout=sys.STDOUT, stderr=sys.STDERR)
    p.wait()
    return p.return_code

# nginx
os.symlink(j(this_dir, 'nginx_configs', 'site', 'nginx-%s.conf' % staging), j(nginx_dir, 'site-nginx-%s.conf' % staging))
os.symlink(j(this_dir, 'nginx_configs', 'deploy', 'nginx-%s.conf' % staging), j(nginx_dir, 'deploy-nginx-%s.conf' % staging))

# uwsgi for the site
site_uwsgi_ini = j(this_dir, 'site', 'uwsgi-%s.ini' % staging)
site_upstart_template = open(j(this_dir, 'site', 'upstart-uwsgi.conf'), "r").read()
site_upstart = site_upstart_template.format(UWSGI_INI_LOCATION='site_uwsgi_ini',
                                            UWSGI_FOR='appcubator-site')

with open(j(upstart_dir, 'uwsgi-site.conf'), "w") as upstart_dest:
    upstart_dest.write(site_upstart)

# uwsgi for the deployment
deploy_uwsgi_ini = j(this_dir, 'deploy', 'uwsgi-%s.ini' % staging)
deploy_upstart_template = open(j(this_dir, 'deploy', 'upstart-uwsgi.conf'), "r").read()
deploy_upstart = deploy_upstart_template.format(UWSGI_INI_LOCATION='deploy_uwsgi_ini',
                                            UWSGI_FOR='appcubator-deploy')

with open(j(upstart_dir, 'uwsgi-deploy.conf'), "w") as upstart_dest:
    upstart_dest.write(site_upstart)
