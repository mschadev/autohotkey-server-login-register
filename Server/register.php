<?php
require_once 'includes/config.php';
$securitycode = $_POST['securitycode'];
$useragent = $_SERVER['HTTP_USER_AGENT'];
$id = $_POST['id'];
$password = $_POST['password'];
$email = $_POST['email'];
$name = $_POST['name'];

$nowTime = date("YmdHi");
$nowTime2 = substr($nowTime, 0, strlen($nowTime) - 1);
$securitycodeShouldBe = hash('sha512', $nowTime2 . $useragent, false);
if ($securitycode != $securitycodeShouldBe || $useragent != "System-" . SERVERNAME . "-Register") {
    echo "Security Auth Fail";
    return;
}
$stmt = $db->prepare('SELECT id FROM members WHERE id = :id');
$stmt->execute(array(':id' => $id));
$row = $stmt->fetch(PDO::FETCH_ASSOC);
if (!empty($row['id'])) {
    echo "입력하신 아이디가 이미 사용중입니다.";
    return;
} else if (strlen($id) < 4) {
    echo "4자리 이상의 아이디를 사용해야 합니다.";
    return;
} else if (strlen($password) < 6) {
    echo "7자리 이상의 비밀번호를 사용해야 합니다.";
    return;
} else if (!preg_match("/^[_\.0-9a-zA-Z-]+@([0-9a-zA-Z][0-9a-zA-Z-]+\.)+[a-zA-Z]{2,6}$/i", $email)) {
    echo "올바른 이메일 형식이 아닙니다.";
    return;
}
if (!isset($error)) {
    //hash the password
    $hashedpassword = $user->password_hash($password, PASSWORD_BCRYPT);
    //create the activasion code
    $activasion = hash('sha512', uniqid(rand(), true));
    try
    {
        //insert into database with a prepared statement
        $stmt = $db->prepare('INSERT INTO members (joindatetime, id, password, email,name) VALUES (:joindatetime, :id, :password, :email, :name)');
        $stmt->execute(array(
            ':joindatetime' => date("Y-m-d H:i:s"),
            ':id' => $id,
            ':password' => $hashedpassword,
            ':email' => $_POST['email'],
            ':name' => $_POST['name'],
        ));
        echo "성공적으로 회원가입되었습니다.";
    } catch (PDOException $e) {
        echo $e->getMessage();
    }
}
