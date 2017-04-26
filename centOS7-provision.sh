#!/bin/bash
yum update
rpm -ivh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm
rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
yum repolist
yum -y install puppet-agent
/opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true
