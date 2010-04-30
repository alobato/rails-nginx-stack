#!/bin/bash

# http://www.linode.com/stackscripts/

# <udf name="admin_username" label="Admin Username" />
# <udf name="admin_password" label="Admin Password" />
 
source <ssinclude StackScriptID="1">
 
# Update the system and hostname
system_update
 
# Create admin and add SSH key
useradd -m -s /bin/bash $ADMIN_USERNAME
echo "${ADMIN_USERNAME}:${ADMIN_PASSWORD}" | chpasswd

cp /etc/sudoers /etc/sudoers.tmp
chmod 0640 /etc/sudoers.tmp
echo "$ADMIN_USERNAME ALL=(ALL) ALL" >> /etc/sudoers.tmp
chmod 0440 /etc/sudoers.tmp
mv /etc/sudoers.tmp /etc/sudoers
