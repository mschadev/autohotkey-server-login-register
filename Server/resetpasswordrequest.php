<?php
require_once 'includes/config.php';

$securitycode = $_POST['securitycode'];
$useragent = $_SERVER['HTTP_USER_AGENT'];
$id = $_POST['id'];

$nowTime = date("YmdHi");
$nowTime2 = substr($nowTime, 0, strlen($nowTime) - 1);
$securitycodeShouldBe = hash('sha512', $nowTime2 . $useragent . 'resetpassword', false);

if ($securitycode !== $securitycodeShouldBe || $useragent != "System-" . SERVERNAME . "-resetpassword") {
    echo "Security Auth Fail";
    return;
}

$stmt = $db->prepare('SELECT * FROM members WHERE id = :id');
$stmt->execute(array(':id' => $_POST['id']));
$row = $stmt->fetch(PDO::FETCH_ASSOC);
if (empty($row['id'])) {
    echo "해당 아이디는 없습니다.";
    return;
}
//create the activasion code
$token = hash('sha512', uniqid(rand(), true));

try
{
    $stmt = $db->prepare("UPDATE members SET resetToken = :token, resetComplete = :resetComplete WHERE id = :id");
    $stmt->execute(array(
        ':id' => $_POST['id'],
        ':token' => $token,
        ':resetComplete' => 0,
    ));

    //send email
    $to = $row['email'];
    $subject = "비밀번호 초기화";
    $subject = "=?UTF-8?B?" . base64_encode($subject) . "?="; //한글깨짐 패치
    $body = "<a href='" . URL . DIR . "/resetpassword.php?key=$token'>" . URL . DIR . "/resetPassword.php?key=$token</a>";

    $mail = new Mail();
    $mail->IsSMTP(); // telling the class to use SMTP
    //$mail->Host       = "www.coolio.so"; // SMTP server
    $mail->SMTPDebug = 2; // enables SMTP debug information (for testing)
    // 1 = errors and messages
    // 2 = messages
    $mail->SMTPOptions = array(
        'ssl' => array(
            'verify_peer' => false,
            'verify_peer_name' => false,
            'allow_self_signed' => true,
        ),
    );
    $mail->CharSet = "utf-8";
    $mail->SMTPAuth = true; // enable SMTP authentication
    $mail->SMTPSecure = "tls"; // sets the prefix to the servier
    $mail->Host = "smtp.gmail.com"; // sets GMAIL as the SMTP server
    $mail->Port = 587; // set the SMTP port for the GMAIL server
    $mail->id = EMAIL_ID; //GMAIL id
    $mail->Password = EMAIL_PW; // GMAIL password
    $mail->CharSet = 'UTF-8';
    $mail->SMTPAutoTLS = false;
    $mail->setFrom(EMAIL_ID);
    $mail->addAddress($to);
    $mail->subject($subject);
    $mail->body($body);
    $mail->send();
    echo "비밀번호 초기화 메일을 보냈습니다.";
    //else catch the exception and show the error.
} catch (PDOException $e) {
    echo $e->getMessage();
}
