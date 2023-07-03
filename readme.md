# Container solution of Olymp project

This solution assemble parts of Olymp project and up in the containers.

Parts of Olymp project are:

* `olymp-platform`
* `olymp-sandbox`

## Containers

### nginx

The clusters entry point.

### mariadb

MySQL databases are stored in the `./mounts/database` folder, that mounted to the `/var/lib/mysql`.

### php-fpm

Site `olymp-platform` is mounted to the `/var/www/html/` folder.

Folder `./mounts/data/` is mounted to the `/var/www/data` folder. This folder contains submissions, tests and other resources.

### sandbox

Folder `./mounts/data/` is mounted to the `/data` folder. This folder contains submissions, tests and other resources. Sandbox check database for new submission detection. If found, compile and test submission.

## How to start

### First start

Prepare environment by submodules downloading and infrastructure creating.

```bash
# download submodules
git submodule init
git submodule update

# create folders
make init
```

After that you can build images and up claster:

```bash
make build
make up
```

Other commands you may check by running `make help`.