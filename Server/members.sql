-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- 생성 시간: 19-04-07 21:31
-- 서버 버전: 5.7.25
-- PHP 버전: 5.6.40

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 데이터베이스: `a`
--

-- --------------------------------------------------------

--
-- 테이블 구조 `members`
--

CREATE TABLE `members` (
  `joinDateTime` datetime NOT NULL,
  `id` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(50) NOT NULL,
  `name` tinytext NOT NULL,
  `resetToken` varchar(255) DEFAULT NULL,
  `resetComplete` tinyint(1) DEFAULT NULL,
  `ComputerName1` varchar(255) NOT NULL DEFAULT 'NULL',
  `ComputerHard1` varchar(255) DEFAULT 'NULL',
  `License` varchar(10) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=euckr;

--
-- 테이블의 덤프 데이터 `members`
--

INSERT INTO `members` (`joinDateTime`, `id`, `password`, `email`, `name`, `resetToken`, `resetComplete`, `ComputerName1`, `ComputerHard1`, `License`) VALUES
('2019-03-28 17:01:51', 'test1234', '$2y$10$hOAf1YI49UZ3f0a7uZtUk.irluPKBNR4KfkqNEVSIcYova.oDYdlq', 'test1234@test123.com', 'test', NULL, NULL, 'NULL', 'NULL', NULL);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
