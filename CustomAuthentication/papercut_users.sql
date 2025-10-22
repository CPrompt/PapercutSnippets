-- phpMyAdmin SQL Dump
-- version 5.2.2-1.fc42
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Oct 22, 2025 at 03:21 PM
-- Server version: 10.11.11-MariaDB
-- PHP Version: 8.4.13

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `papercut_users`
--

-- --------------------------------------------------------

--
-- Table structure for table `groups`
--

CREATE TABLE `groups` (
  `groupname` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `group_members`
--

CREATE TABLE `group_members` (
  `groupname` varchar(50) DEFAULT NULL,
  `username` varchar(50) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `fullname` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `dept` varchar(50) DEFAULT NULL,
  `office` varchar(50) DEFAULT NULL,
  `cardno` varchar(20) DEFAULT NULL,
  `otherEmails` varchar(100) DEFAULT NULL,
  `secondarycardno` varchar(20) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `fullname`, `email`, `dept`, `office`, `cardno`, `otherEmails`, `secondarycardno`, `password`) VALUES
(1, 'bruce.wayne', 'Bruce Wayne', 'bruce@wayneindustries.com', 'Accounting', 'Gotham', '5678', NULL, NULL, '$2b$12$oUvvG2s0.AM3WYDLOURJduBfhq0iDooeXsEUZnk4PSpqrpvKNyAwK'),
(2, 'curtis.adkins', 'Curtis Adkins', 'cadkins@systeloa.com', 'Service', 'Greensboro', '1234', NULL, '6987', '$2y$12$qxYJdjRhe1bc68WUmj5CIuSF79W2gYiR.I30dtlVXQwSXsVMsai..'),
(3, 'oliver.queen', 'Oliver Queen', 'oliver@queenindustries.com', 'Administration', 'Star City', '1234', NULL, NULL, '$2b$12$0oJdeMsOkHJ21Kxs4e0ywOc8xe./VdAXiLu8LzrKU0YB3BUsN8f1i');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `groups`
--
ALTER TABLE `groups`
  ADD PRIMARY KEY (`groupname`);

--
-- Indexes for table `group_members`
--
ALTER TABLE `group_members`
  ADD KEY `groupname` (`groupname`),
  ADD KEY `username` (`username`),
  ADD KEY `group_members_ibfk2` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `group_members`
--
ALTER TABLE `group_members`
  ADD CONSTRAINT `group_members_ibfk2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `group_members_ibfk_1` FOREIGN KEY (`groupname`) REFERENCES `groups` (`groupname`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
