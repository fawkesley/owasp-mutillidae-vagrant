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
  RESULT="$(curl http://localhost/phpinfo.php)"
}

install_multillidae() {
  rm -rf /var/www/multillidae
  cp -R /vagrant/external/multillidae /var/www/multillidae
}


pull_latest_multillidae() {
  cd /vagrant/external/multillidae
  git pull
}

# apt_update
install_apache
tweak_apache_dir_conf
install_mysql
install_php_5
install_phpinfo
test_php
# pull_latest_multillidae
install_multillidae
