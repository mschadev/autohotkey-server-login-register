<?php
//set timezone
date_default_timezone_set('Asia/Seoul');
header('Content-Type: text/html; charset=utf-8');

define('DIR', 'Server'); //디렉터리 명
define('SERVERNAME', 'Server'); //서버 이름,클라이언트 Server 클래스랑 동일해야함
define('URL', 'http://example.com/'); //웹 URL
//database
define('DBHOST', 'localhost');
define('DBUSER', 'dbid');
define('DBPASS', 'dbpw');
define('DBNAME', 'dbname');

//email
define('EMAIL_ID', ''); //구글 이메일 아이디
define('EMAIL_PW', ''); //구글 이메일 비밀번호

try
{
    //create PDO connection
    $db = new PDO("mysql:host=" . DBHOST . ";dbname=" . DBNAME, DBUSER, DBPASS);
    $db->exec("set names utf8");
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    //show error
    echo $e->getMessage();
    exit;
}

//include the user class, pass in the database connection
include $_SERVER['DOCUMENT_ROOT'] . '/' . DIR . '/classes/user.php';
include $_SERVER['DOCUMENT_ROOT'] . '/' . DIR . '/classes/phpmailer/mail.php';
$user = new User($db);
