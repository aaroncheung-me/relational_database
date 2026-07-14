<?php
// copy to config.php and fill in real values, or set these as env vars
// on your server. config.php is gitignored, don't commit it.

return [
    'host'     => getenv('DB_HOST') ?: 'localhost',
    'db_name'  => getenv('DB_NAME') ?: 'your_database_name',
    'username' => getenv('DB_USER') ?: 'your_db_username',
    'password' => getenv('DB_PASS') ?: 'your_db_password',
];