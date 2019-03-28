<?php
require_once 'includes/config.php';
$id = $_POST['id'];
$password = $_POST['password'];
$securitycode = $_POST['securitycode'];
$useragent = $_SERVER['HTTP_USER_AGENT'];
$hardnumber = $_POST['hardnumber'];
$pcname = $_POST['pcname'];

$nowTime = date("YmdHi");
$nowTime2 = substr($nowTime, 0, strlen($nowTime) - 1);
$securitycodeShouldBe = hash('sha512', $nowTime2 . $id . 'login', false);
if ($securitycode != $securitycodeShouldBe || $useragent != "System-" . SERVERNAME . "-Login") {
    echo "Security Auth Fail";
    return;
}
if (!empty($securitycode) &&
    !empty($id) &&
    !empty($password) &&
    !empty($hardnumber) &&
    !empty($pcname)) {
    $result = $user->login($id, $password, $hardnumber, $pcname);
    switch ($result) {
        case -1:
            //라이센스 없음
            echo '<answer="' . hash('sha512', $nowTime2 . $id . 'NotLicense', false) . '">';
            break;
        case 0:
            //로그인 실패
            echo '<answer="' . hash('sha512', $nowTime2 . $id . 'wrong', false) . '">';
            break;
        case 1:
            //로그인 성공
            echo '<answer="' . hash('sha512', $nowTime2 . $id . 'alright', false) . '">';
            break;
    }
} else {
    echo "argument empty";
}
