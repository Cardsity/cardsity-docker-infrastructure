#!/bin/bash

# Echo information and banner
echo ' .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------. '
echo '| .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |'
echo '| |     ______   | || |      __      | || |  _______     | || |  ________    | || |    _______   | || |     _____    | || |  _________   | || |  ____  ____  | |'
echo $'| |   .\' ___  |  | || |     /  \     | || | |_   __ \    | || | |_   ___ `.  | || |   /  ___  |  | || |    |_   _|   | || | |  _   _  |  | || | |_  _||_  _| | |'
echo $'| |  / .\'   \_|  | || |    / /\ \    | || |   | |__) |   | || |   | |   `. \ | || |  |  (__ \_|  | || |      | |     | || | |_/ | | \_|  | || |   \ \  / /   | |'
echo $'| |  | |         | || |   / ____ \   | || |   |  __ /    | || |   | |    | | | || |   \'.___`-.   | || |      | |     | || |     | |      | || |    \ \/ /    | |'
echo $'| |  \ `.___.\'\  | || | _/ /    \ \_ | || |  _| |  \ \_  | || |  _| |___.\' / | || |  |`\____) |  | || |     _| |_    | || |    _| |_     | || |    _|  |_    | |'
echo $'| |   `._____.\'  | || ||____|  |____|| || | |____| |___| | || | |________.\'  | || |  |_______.\'  | || |    |_____|   | || |   |_____|    | || |   |______|   | |'
echo '| |              | || |              | || |              | || |              | || |              | || |              | || |              | || |              | |'
echo $'| \'--------------\' || \'--------------\' || \'--------------\' || \'--------------\' || \'--------------\' || \'--------------\' || \'--------------\' || \'--------------\' |'
echo $' \'----------------\'  \'----------------\'  \'----------------\'  \'----------------\'  \'----------------\'  \'----------------\'  \'----------------\'  \'----------------\' '
echo
echo "Cardsity is an open-source Cards Against Humanity clone."
echo "Every part of the software can be found on GitHub: https://github.com/Cardsity"
echo "Cardsity was made by the Cardsity Team: https://github.com/orgs/Cardsity/people"
echo
echo "This script will create a configuration file which can be used in combinaton with the docker images to run the server."
echo
echo

# Check if there's already a configuration file
if [ -f cardsity.conf ]; then
  read -r -p "There's already a configuration file for the server. By continuing, this file will be overwritten. Are you sure you want to continue? [y/N] " result_overwrite_config
  case $result_overwrite_config in
    [yY])
      mv cardsity.conf cardsity.conf.old
      ;;
    *)
      exit 1
    ;;
  esac
fi

# Generates a random string with the length of $1
random_string () {
  echo -n "$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $1 | head -n 1)"
}

# Ask for the urls oon which the server is reachable
read -r -p "Enter the domain of the frontend and the server: " FRONTEND_HOST
read -r -p "Enter the domain of the deck server: " DECK_SERVER_HOST

# Generate the mysql options
read -r -p "Enter the mysql username [cardsity]: " MYSQL_USERNAME
MYSQL_USERNAME=${MYSQL_USERNAME:-cardsity}
MYSQL_DATABASE=$MYSQL_USERNAME
echo "For the mysql password, a random, alphanumeric, 32 characters long string will be used."
MYSQL_ROOT_PASSWORD=$(random_string 32)
MYSQL_PASSWORD=$(random_string 32)

# Django specific options
DJANGO_SECRET_KEY=$(random_string 64)
DJANGO_ALLOWED_HOSTS="${DECK_SERVER_HOST},cds"

cat << EOF > cardsity.conf
# ======================
# Cardsity configuration
# ======================

# Host configuration
HOST_FRONTEND=${FRONTEND_HOST}
HOST_DECK_SERVER=${DECK_SERVER_HOST}

# Django configuration
DJANGO_SECRET_KEY=${DJANGO_SECRET_KEY}
DJANGO_ALLOWED_HOSTS=${DJANGO_ALLOWED_HOSTS}

# MySQL configuration
MYSQL_USERNAME=${MYSQL_USERNAME}
MYSQL_DATABASE=${MYSQL_DATABASE}
MYSQL_PASSWORD=${MYSQL_PASSWORD}
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}

EOF

# Make the directory for the ssl certificates
mkdir -p ssl

# Echo final messages
# TODO: Update the url to the right page
echo "The configuration file has been generated. For more information about how to proceed, visit our wiki at https://docs.cardsity.app."