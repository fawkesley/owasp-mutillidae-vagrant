#!/bin/sh -eux

THIS_SCRIPT="$0"
THIS_DIR="$(dirname $0)"

install_file() {
  DEST_FILE=$1
  SOURCE_FILE="/vagrant/config/skel/${DEST_FILE}"
  mkdir -p "$(dirname ${DEST_FILE})"
  cp "${SOURCE_FILE}" "${DEST_FILE}"
}

apt_update() {
  apt update
  echo
}

install_git() {
  apt install -y git
}

install_apache() {
  apt install -y apache2 apache2-utils
}

tweak_apache_dir_conf() {
  install_file /etc/apache2/mods-enabled/dir.conf
  service apache2 restart
}

install_mysql() {
  echo "mysql-server-5.5 mysql-server/root_password password \"''\"" | debconf-set-selections
  echo "mysql-server-5.5 mysql-server/root_password_again password \"''\"" | debconf-set-selections
  apt install -y mysql-server libapache2-mod-auth-mysql php5-mysql
  mysql_install_db
}

install_php_5() {
  sudo apt-get install -y php5 php5-mysql php-pear php5-gd  php5-mcrypt php5-curl
}

install_phpinfo() {
  echo '<?php phpinfo(); ?>' > /var/www/html/phpinfo.php
}

test_php() {
  curl http://localhost/phpinfo.php |grep PHP
  if [ $? -ne 0 ]; then
    echo "Problem with phpinfo.php..."
    exit 1
  fi
}

pull_latest_mutillidae() {
  GIT_REPO="git://git.code.sf.net/p/mutillidae/git"

  if [ ! -d "/vagrant/external/mutillidae" ]; then
    cd /vagrant/external
    git clone "${GIT_REPO}" mutillidae
  else
    cd /vagrant/external/mutillidae
    git remote set-url origin "${GIT_REPO}"
    git fetch
    git checkout master
    git reset --hard origin/master
  fi
}

install_mutillidae() {
  rm -rf /var/www/html/mutillidae
  cp -R /vagrant/external/mutillidae /var/www/html/mutillidae
}


show_message() {
  echo
  echo "Now browse to http://localhost:8080/mutillidae/set-up-database.php"
}

install_git
install_apache
tweak_apache_dir_conf
install_mysql
install_php_5
install_phpinfo
test_php
pull_latest_mutillidae
install_mutillidae
show_message
