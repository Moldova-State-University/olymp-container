<?php

$dataDir = "/my/cool/path";

$nrConsumers = 10;
$consumerTimeOut = 1;
$producerTimeOut = 1;


$dbuser = getenv("MARIADB_USER");
$dbname = getenv("MARIADB_DATABASE");
$dbpass = getenv("MARIADB_PASSWORD");
$dbhost = getenv("MARIADBHOST");

$dsn = "mysql:host={$dbhost};dbname={$dbname}";