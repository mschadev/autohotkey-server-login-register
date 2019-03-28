<?php
require_once 'PHPMailer.php';
class Mail extends PHPMailer\PHPMailer\PHPMailer
{
    // Set default variables for all new objects
   /* public $From     = 'epcoin.webmaster@gmail.com';
    public $FromName = 'epcoin.webmaster@gmail.com';
    public $Host     = 'smtp.gmail.com';
    public $Mailer   = 'smtp';
    public $SMTPAuth = true;
    public $Username = 'epcoin.webmaster@gmail.com';
    public $Password = 'Zxc15975!';
    public $SMTPSecure = 'tls';
	*/
    public $WordWrap = 75;

    public function subject($subject)
    {
        $this->Subject = $subject;
    }

    public function body($body)
    {
        $this->Body = $body;
    }

    public function send()
    {
        $this->AltBody = strip_tags(stripslashes($this->Body))."\n\n";
        $this->AltBody = str_replace("&nbsp;", "\n\n", $this->AltBody);
        return parent::send();
    }
}
