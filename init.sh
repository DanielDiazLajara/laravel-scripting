#!/bin/bash

h_flag=''
s_flag=''
w_flag=''

print_usage(){
  printf "Laravel-scripting :: init\n"
  printf "__________________________________________________________\n\n"
  printf "USAGE:\n"
  printf "Use -s (soft) for clearing cache and database.\n"
  printf "Use -h (hard) for reinstalling all the dependencies.\n"
  printf "Use -w to run watch-poll.\n"
}

while getopts 'hsw' flag; do
  case "${flag}" in
    h) h_flag='true';;
    s) s_flag='true';;
    w) w_flag='true';;
    *) print_usage
       exit 1;;
  esac
done

if [[ "${s_flag}" == 'true' ]];
then
  cd mycomplynow
  php artisan export:messages-flat
  php artisan migrate:fresh --seed

  php artisan cache:clear
  php artisan config:cache
  php artisan config:clear
  php artisan route:cache

 php artisan ziggy:generate
fi

if [[ "${h_flag}" == 'true' ]];
then
  composer dump-autoload
  rm -rf vendor
  sudo composer install
  rm -rf node-modules
  yarn install
else
  echo ""
fi

if [[ "${w_flag}" == 'true' ]];
then
  npm run watch-poll
fi