#!/usr/bin/env bash
: '
@date: July 17 2019
@author: Drew Ruppel <drewruppel@gmail.com>
@project: cisco anyconnect cli dis/connnect

Reads credentials from a file defined in CRED_FILE which should contain
a username and a password with no other definitions than itself on two
separate lines.  CRED_FILE location can be modified as you see fit.


e.g.
  drew
  password
'

### Constants
CREDS_ARRAY=()
CRED_PATH="/home/$USER/.secrets/"
CRED_FILE="vpn.creds"
BIN="/opt/cisco/anyconnect/bin/vpn"
STDIN="-s"
CONNECT_TO=""
DUO_KEY=""

### Functions
credentials() {
  echo "${CREDS_ARRAY[0]}\n${CREDS_ARRAY[1]}\n$DUO_KEY\ny"
}

connect() {
  CREDS_ARRAY=(`cat "$CRED_PATH$CRED_FILE"`)

  if [[ ${#CREDS_ARRAY[@]} -eq 0 ]]; then
    printf "Your $CRED_FILE could not be found or was empty/malformed.\n"
  else
    printf $(credentials) | eval "$BIN $STDIN $ACTION $CONNECT_TO"
  fi
}

disconnect() {
  eval "$BIN $ACTION"
}

error() {
  printf "$ACTION command not recognized\nPlease use either connect or disconnect..\n"
}

empty() {
  printf "No command entered.  Please use either connect or disconnect.\n"
}

ACTION=$1

### Main
if [[ -z $ACTION ]]; then
  empty
elif [[ $ACTION = "connect" ]]; then
  connect
elif [[ $ACTION = "disconnect" ]]; then
  disconnect
else
  error
fi
