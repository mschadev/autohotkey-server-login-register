<?php
include 'password.php';

class User extends Password
{
    private $_db;

    public function __construct($db)
    {
        parent::__construct();

        $this->_db = $db;
    }

    private function get_user_hash($id)
    {
        try
        {
            $stmt = $this->_db->prepare('SELECT joindatetime, password,License,id,ComputerHard1 FROM members WHERE id = :id');
            $stmt->execute(array(
                'id' => $id,
            ));

            return $stmt->fetch();

        } catch (PDOException $e) {
            echo '<p class="bg-danger">' . $e->getMessage() . '</p>';
        }
    }

    public function login($id, $password, $hardnumber, $pcname)
    {
        $row = $this->get_user_hash($id);

        if ($this->password_verify($password, $row['password'])) {
            /*$_SESSION['loggedin'] = true;
            $_SESSION['id'] = $row['id'];
            $_SESSION['joindatetime'] = $row['joindatetime'];
             */
            $date = (strtotime($row['License']) - strtotime(date("Y-m-d", time()))) / 86400;
            if ($date <= -1) {
                return -1;
            }
            if ($row['ComputerHard1'] == "NULL" || $row['ComputerHard1'] == null) {
                $stmt = $this->_db->prepare("UPDATE members SET ComputerName1 = :pcname,ComputerHard1 = :ComputerHard2 WHERE id = :id");
                $stmt->bindParam(':ComputerHard2', $hardnumber);
                $stmt->bindParam(':id', $id);
                $stmt->bindParam(':pcname', $pcname);
                $stmt->execute();
                return 1;
            } else if ($row['ComputerHard1'] == $hardnumber) {
                return 1;
            } else if ($row['ComputerHard1'] != $hardnumber) {
                return 0;
            }
        }
    }

}
