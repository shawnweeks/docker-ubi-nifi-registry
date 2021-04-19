#!/usr/bin/python3

from entrypoint_helpers import env, gen_cfg

HOME = env["HOME"]

gen_cfg("authorizers.xml.j2", "{}/conf/authorizers.xml".format(HOME))
gen_cfg("bootstrap.conf.j2", "{}/conf/bootstrap.conf".format(HOME))
gen_cfg("identity-providers.xml.j2", "{}/conf/identity-providers.xml".format(HOME))
gen_cfg("logback.xml.j2", "{}/conf/logback.xml".format(HOME))
gen_cfg("nifi-registry.properties.j2", "{}/conf/nifi-registry.properties".format(HOME))
gen_cfg("providers.xml.j2", "{}/conf/providers.xml".format(HOME))
gen_cfg("registry-aliases.xml.j2", "{}/conf/registry-aliases.xml".format(HOME))