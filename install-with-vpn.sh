main() {
  SOURCES_FETCHED=false
    if [ ! -f /etc/apt/sources.list.d/nodesource.list ]; then
      curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
    fi
    if ! apt-cache madison nodejs | grep -q node_12; then
      err "Did not detect nodejs 12.x candidate for installation"
    fi
    if ! apt-key list MongoDB | grep -q 4.2; then
      wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
    fi
    echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list
    rm -f /etc/apt/sources.list.d/mongodb-org-4.0.list

    touch /root/.rnd
    MONGODB=mongodb-org
    install_docker		# needed for bbb-libreoffice-docker
    need_pkg ruby
    gem install bundler -v 2.1.4

    apt-get update
    apt-get dist-upgrade -yq

    need_pkg nodejs $MONGODB apt-transport-https haveged build-essential yq

    docker pull themaqs/gl:latest
    docker pull postgres:13.2-alpine
}

check_root() {
  if [ $EUID != 0 ]; then err "You must run this command as root."; fi
}

need_pkg() {
  check_root

  if [ ! "$SOURCES_FETCHED" = true ]; then
    apt-get update
    SOURCES_FETCHED=true
  fi

  if ! dpkg -s ${@:1} >/dev/null 2>&1; then
    LC_CTYPE=C.UTF-8 apt-get install -yq ${@:1}
  fi
}


install_docker() {
  need_pkg apt-transport-https ca-certificates curl gnupg-agent software-properties-common openssl

  # Install Docker
  if ! apt-key list | grep -q Docker; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
  fi

  if ! dpkg -l | grep -q docker-ce; then
    add-apt-repository \
     "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) \
     stable"

    apt-get update
    need_pkg docker-ce docker-ce-cli containerd.io
  fi
  if ! which docker; then err "Docker did not install"; fi

  if dpkg -l | grep -q docker-compose; then
    apt-get purge -y docker-compose
  fi

  if [ ! -x /usr/local/bin/docker-compose ]; then
    curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
  fi
}

main "$@" || exit 1