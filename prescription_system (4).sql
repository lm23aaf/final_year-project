-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 27, 2026 at 08:32 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `prescription_system`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin_users`
--

CREATE TABLE `admin_users` (
  `admin_id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `role_level` int(11) DEFAULT NULL CHECK (`role_level` between 1 and 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin_users`
--

INSERT INTO `admin_users` (`admin_id`, `full_name`, `role_level`) VALUES
(1, 'System Administrator', 5);

-- --------------------------------------------------------

--
-- Table structure for table `audit_log`
--

CREATE TABLE `audit_log` (
  `log_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `action` varchar(100) DEFAULT NULL,
  `target_table` varchar(100) DEFAULT NULL,
  `target_id` int(11) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `audit_log`
--

INSERT INTO `audit_log` (`log_id`, `user_id`, `action`, `target_table`, `target_id`, `timestamp`) VALUES
(1, 1, 'DELETE', 'blockchain_blocks', 9, '2026-03-23 18:59:37'),
(2, 1, 'LOGIN_SUCCESS', 'users', 1, '2026-03-24 09:26:28'),
(3, 1, 'LOGIN_SUCCESS', 'users', 1, '2026-03-24 10:12:43'),
(4, 2, 'LOGIN_SUCCESS', 'users', 2, '2026-03-24 10:12:59'),
(5, NULL, 'LOGIN_FAILED', 'users', NULL, '2026-03-24 10:22:33'),
(6, 1, 'LOGIN_SUCCESS', 'users', 1, '2026-03-24 10:25:11'),
(7, 2, 'LOGIN_SUCCESS', 'users', 2, '2026-03-24 10:54:35'),
(8, 1, 'LOGIN_SUCCESS', 'users', 1, '2026-03-24 11:40:20'),
(9, 1, 'LOGIN_SUCCESS', 'users', 1, '2026-03-24 12:54:17'),
(10, NULL, 'LOGIN_FAILED', 'users', NULL, '2026-03-24 13:04:03'),
(11, 1, 'LOGIN_SUCCESS', 'users', 1, '2026-03-24 13:04:16'),
(12, 1, 'LOGIN_SUCCESS', 'users', 1, '2026-03-24 14:15:25'),
(13, 2, 'LOGIN_SUCCESS', 'users', 2, '2026-03-24 14:48:38'),
(14, 1, 'LOGIN_SUCCESS', 'users', 1, '2026-03-24 21:47:30'),
(15, 2, 'LOGIN_SUCCESS', 'users', 2, '2026-03-24 21:59:16'),
(16, 1, 'LOGIN_SUCCESS', 'users', 1, '2026-03-24 22:20:37'),
(17, NULL, 'LOGIN_FAILED', 'users', NULL, '2026-03-24 22:26:50'),
(18, 1, 'LOGIN_SUCCESS', 'users', 1, '2026-03-24 22:27:02'),
(19, 1, 'LOGIN_SUCCESS', 'users', 1, '2026-03-24 22:27:44'),
(20, 1, 'LOGIN_SUCCESS', 'users', 1, '2026-03-24 22:43:06'),
(21, NULL, 'UPDATE_BLOCK', 'blockchain_blocks', 4, '2026-03-25 12:57:36'),
(22, NULL, 'UPDATE_BLOCK', 'blockchain_blocks', 5, '2026-03-25 12:57:36'),
(23, 1, 'LOGIN_SUCCESS', 'users', 1, '2026-03-25 13:14:26'),
(24, 1, 'ADD_TRANSACTION', 'blockchain_transactions', 6, '2026-03-25 13:14:44'),
(25, 5, 'LOGIN_SUCCESS', 'users', 5, '2026-03-25 13:18:03'),
(26, 1, 'LOGIN_SUCCESS', 'users', 1, '2026-03-25 19:43:59'),
(27, 5, 'LOGIN_SUCCESS', 'users', 5, '2026-03-25 20:19:13'),
(28, 4, 'LOGIN_SUCCESS', 'users', 4, '2026-03-25 20:19:59'),
(29, 1, 'LOGIN_SUCCESS', 'users', 1, '2026-03-25 20:23:39'),
(30, 4, 'LOGIN_SUCCESS', 'users', 4, '2026-03-25 20:25:40'),
(31, NULL, 'ADD_TRANSACTION', 'blockchain_transactions', 6, '2026-03-25 20:26:50'),
(32, 1, 'LOGIN_SUCCESS', 'users', 1, '2026-03-25 20:43:16'),
(33, 1, 'ADD_TRANSACTION', 'blockchain_transactions', 6, '2026-03-25 20:44:15'),
(34, 4, 'LOGIN_SUCCESS', 'users', 4, '2026-03-25 21:11:44'),
(35, 4, 'ADD_TRANSACTION', 'blockchain_transactions', 7, '2026-03-25 21:12:40'),
(36, 1, 'LOGIN_SUCCESS', 'users', 1, '2026-03-25 21:13:52'),
(37, 2, 'LOGIN_SUCCESS', 'users', 2, '2026-03-25 21:15:49'),
(38, 5, 'LOGIN_SUCCESS', 'users', 5, '2026-03-25 21:38:32'),
(39, 5, 'LOGOUT', 'users', 5, '2026-03-25 21:38:47'),
(40, NULL, 'LOGIN_FAILED', 'users', NULL, '2026-03-25 21:38:59'),
(41, 1, 'LOGIN_SUCCESS', 'users', 1, '2026-03-25 23:04:23'),
(42, 1, 'LOGOUT', 'users', 1, '2026-03-25 23:06:33'),
(46, 1, 'LOGIN_SUCCESS', 'users', 1, '2026-03-25 23:24:21'),
(47, 1, 'LOGOUT', 'users', 1, '2026-03-25 23:24:36'),
(51, 1, 'LOGIN_SUCCESS', 'users', 1, '2026-03-25 23:34:01'),
(52, 1, 'LOGOUT', 'users', 1, '2026-03-25 23:34:05'),
(56, 1, 'LOGIN_SUCCESS', 'users', 1, '2026-03-26 00:06:08'),
(57, 1, 'LOGOUT', 'users', 1, '2026-03-26 00:06:16'),
(60, NULL, 'LOGIN_FAILED', 'users', NULL, '2026-03-26 00:16:53'),
(62, 1, 'LOGIN_SUCCESS', 'users', 1, '2026-03-26 00:19:08'),
(63, 2, 'LOGIN_SUCCESS', 'users', 2, '2026-03-26 00:19:27'),
(66, 1, 'LOGIN_SUCCESS', 'users', 1, '2026-03-26 00:26:06'),
(67, 1, 'ADD_TRANSACTION', 'blockchain_transactions', 7, '2026-03-26 00:27:03'),
(68, NULL, 'UPDATE_BLOCK', 'blockchain_blocks', 1, '2026-03-26 00:28:09'),
(69, NULL, 'UPDATE_BLOCK', 'blockchain_blocks', 2, '2026-03-26 00:28:09'),
(70, NULL, 'UPDATE_BLOCK', 'blockchain_blocks', 3, '2026-03-26 00:28:09'),
(71, NULL, 'UPDATE_BLOCK', 'blockchain_blocks', 4, '2026-03-26 00:28:09'),
(72, NULL, 'UPDATE_BLOCK', 'blockchain_blocks', 5, '2026-03-26 00:28:09'),
(73, NULL, 'UPDATE_BLOCK', 'blockchain_blocks', 6, '2026-03-26 00:28:09'),
(74, NULL, 'UPDATE_BLOCK', 'blockchain_blocks', 7, '2026-03-26 00:28:09'),
(75, NULL, 'UPDATE_BLOCK', 'blockchain_blocks', 8, '2026-03-26 00:28:09'),
(76, 1, 'REPAIR_BLOCKCHAIN', 'blockchain_blocks', NULL, '2026-03-26 00:28:09'),
(77, 1, 'EXIT', 'users', 1, '2026-03-26 00:28:42'),
(78, NULL, 'LOGIN_FAILED', 'users', NULL, '2026-03-26 00:34:30'),
(79, NULL, 'LOGIN_FAILED', 'users', NULL, '2026-03-26 00:34:42'),
(80, NULL, 'LOGIN_FAILED', 'users', NULL, '2026-03-26 00:42:41'),
(81, 5, 'LOGIN_SUCCESS', 'users', 5, '2026-03-26 00:42:50'),
(82, 5, 'EXIT', 'users', 5, '2026-03-26 00:42:52'),
(83, 1, 'LOGIN_FAILED', 'users', 1, '2026-03-26 00:43:04'),
(84, 1, 'LOGIN_SUCCESS', 'users', 1, '2026-03-26 01:19:44'),
(85, 1, 'EXIT', 'users', 1, '2026-03-26 01:44:52'),
(86, 4, 'LOGIN_SUCCESS', 'users', 4, '2026-03-26 01:45:02'),
(87, 1, 'LOGIN_SUCCESS', 'users', 1, '2026-03-26 02:01:23'),
(88, NULL, 'UPDATE_BLOCK', 'blockchain_blocks', 2, '2026-03-26 02:09:25'),
(89, NULL, 'UPDATE_BLOCK', 'blockchain_blocks', 3, '2026-03-26 02:09:36'),
(90, 1, 'LOGIN_SUCCESS', 'users', 1, '2026-03-26 02:15:47'),
(91, 1, 'LOGIN_SUCCESS', 'users', 1, '2026-03-26 02:20:04'),
(92, 1, 'LOGOUT', 'users', 1, '2026-03-26 02:22:29'),
(0, 5, 'LOGIN_SUCCESS', 'users', 5, '2026-03-26 16:13:28'),
(0, NULL, 'UPDATE_BLOCK', 'blockchain_blocks', 1, '2026-03-26 16:16:25'),
(0, NULL, 'UPDATE_BLOCK', 'blockchain_blocks', 2, '2026-03-26 16:16:25'),
(0, NULL, 'UPDATE_BLOCK', 'blockchain_blocks', 2, '2026-03-26 16:16:25'),
(0, NULL, 'UPDATE_BLOCK', 'blockchain_blocks', 3, '2026-03-26 16:16:25'),
(0, NULL, 'UPDATE_BLOCK', 'blockchain_blocks', 3, '2026-03-26 16:16:25'),
(0, NULL, 'UPDATE_BLOCK', 'blockchain_blocks', 4, '2026-03-26 16:16:25'),
(0, NULL, 'UPDATE_BLOCK', 'blockchain_blocks', 4, '2026-03-26 16:16:25'),
(0, NULL, 'UPDATE_BLOCK', 'blockchain_blocks', 5, '2026-03-26 16:16:25'),
(0, NULL, 'UPDATE_BLOCK', 'blockchain_blocks', 5, '2026-03-26 16:16:25'),
(0, NULL, 'UPDATE_BLOCK', 'blockchain_blocks', 6, '2026-03-26 16:16:25'),
(0, NULL, 'UPDATE_BLOCK', 'blockchain_blocks', 6, '2026-03-26 16:16:25'),
(0, NULL, 'UPDATE_BLOCK', 'blockchain_blocks', 7, '2026-03-26 16:16:25'),
(0, NULL, 'UPDATE_BLOCK', 'blockchain_blocks', 7, '2026-03-26 16:16:25'),
(0, NULL, 'UPDATE_BLOCK', 'blockchain_blocks', 8, '2026-03-26 16:16:25'),
(0, NULL, 'UPDATE_BLOCK', 'blockchain_blocks', 8, '2026-03-26 16:16:25'),
(0, 5, 'LOGIN_SUCCESS', 'users', 5, '2026-03-26 16:18:17');

-- --------------------------------------------------------

--
-- Table structure for table `blockchain_blocks`
--

CREATE TABLE `blockchain_blocks` (
  `block_id` int(11) NOT NULL,
  `previous_hash` char(64) DEFAULT NULL,
  `block_hash` char(64) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_sealed` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `blockchain_blocks`
--

INSERT INTO `blockchain_blocks` (`block_id`, `previous_hash`, `block_hash`, `created_at`, `is_sealed`) VALUES
(1, 'GENESIS', 'fcd09e72993b247c2deb5ee1f985f7566980eb70d526cadeb24fb59924484240', '2026-03-16 21:36:50', 1),
(2, 'fcd09e72993b247c2deb5ee1f985f7566980eb70d526cadeb24fb59924484240', '2195ef7880ff1d1fd05f9d6fe08103d65ba7f7d5322d8964bc41a1bcfa99c701', '2026-03-17 10:14:20', 0),
(3, '2195ef7880ff1d1fd05f9d6fe08103d65ba7f7d5322d8964bc41a1bcfa99c701', '997f11f7f41a456a2cc42f2c902508ee97bcd2dfb98221fae25c5519453448bc', '2026-03-17 10:15:04', 0),
(4, '997f11f7f41a456a2cc42f2c902508ee97bcd2dfb98221fae25c5519453448bc', '81ab3697d2c8fc571f14ee1426b5dde030702de2d81ecda6f1b7336ee29dbfc5', '2026-03-17 10:15:26', 1),
(5, '81ab3697d2c8fc571f14ee1426b5dde030702de2d81ecda6f1b7336ee29dbfc5', '59d86e82ac03eb1bcc23a68731768f51720e03743a5540aa13e38676e5dc3572', '2026-03-17 10:15:46', 1),
(6, '59d86e82ac03eb1bcc23a68731768f51720e03743a5540aa13e38676e5dc3572', '81d0a242d23fb16c19f24cdcb8b7a5b1a77a5700db56a35b43f6d2006564e4ec', '2026-03-17 10:16:30', 0),
(7, '81d0a242d23fb16c19f24cdcb8b7a5b1a77a5700db56a35b43f6d2006564e4ec', 'c9aa7ceabe135bf2788c13b54f6974eb32aefbdb17603fe6e4ba25e3893fbf71', '2026-03-17 10:16:58', 0),
(8, 'c9aa7ceabe135bf2788c13b54f6974eb32aefbdb17603fe6e4ba25e3893fbf71', 'e4453eda98872fae512d453025be355e379f4754c42a2263f709214aedb1679c', '2026-03-17 10:17:16', 0);

--
-- Triggers `blockchain_blocks`
--
DELIMITER $$
CREATE TRIGGER `audit_block_delete` AFTER DELETE ON `blockchain_blocks` FOR EACH ROW BEGIN
    INSERT INTO audit_log (
        user_id,
        action,
        target_table,
        target_id
    )
    VALUES (
        1,
        'DELETE',
        'blockchain_blocks',
        OLD.block_id
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `audit_block_insert` AFTER INSERT ON `blockchain_blocks` FOR EACH ROW BEGIN
    INSERT INTO audit_log (
        user_id,
        action,
        target_table,
        target_id
    )
    VALUES (
        1,
        'INSERT',
        'blockchain_blocks',
        NEW.block_id
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `audit_block_update` AFTER UPDATE ON `blockchain_blocks` FOR EACH ROW BEGIN
    INSERT INTO audit_log (
        user_id,
        action,
        target_table,
        target_id
    )
    VALUES (
        NULL,
        'UPDATE_BLOCK',
        'blockchain_blocks',
        NEW.block_id
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `prevent_delete_blocks` BEFORE DELETE ON `blockchain_blocks` FOR EACH ROW BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Deletion not allowed on blockchain';
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `blockchain_ledger`
--

CREATE TABLE `blockchain_ledger` (
  `block_id` int(11) NOT NULL,
  `previous_hash` char(64) NOT NULL,
  `block_hash` char(64) NOT NULL,
  `action_type` enum('create_prescription','dispense','modify','cancel') NOT NULL,
  `user_id` int(11) NOT NULL,
  `reference_table` varchar(50) NOT NULL,
  `reference_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `blockchain_transactions`
--

CREATE TABLE `blockchain_transactions` (
  `transaction_id` int(11) NOT NULL,
  `block_id` int(11) DEFAULT NULL,
  `action_type` varchar(50) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `reference_table` varchar(50) DEFAULT NULL,
  `reference_id` int(11) DEFAULT NULL,
  `transaction_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`transaction_data`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `blockchain_transactions`
--

INSERT INTO `blockchain_transactions` (`transaction_id`, `block_id`, `action_type`, `user_id`, `reference_table`, `reference_id`, `transaction_data`, `created_at`) VALUES
(1, 1, 'create_prescription', 2, 'prescriptions', 1, '{\"patient_id\":4,\"doctor_id\":2}', '2026-03-16 21:38:49'),
(2, 1, 'add_prescription_item', 2, 'prescription_items', 1, '{\"drug\":\"Amoxicillin\",\"dosage\":\"500mg\"}', '2026-03-16 21:38:49'),
(3, 1, 'add_prescription_item', 2, 'prescription_items', 2, '{\"drug\":\"Paracetamol\",\"dosage\":\"650mg\"}', '2026-03-16 21:38:49'),
(4, 1, 'review_prescription', 3, 'prescriptions', 1, '{\"reviewed_by\":\"pharmacist\"}', '2026-03-16 21:38:49'),
(5, 1, 'dispense_prescription', 3, 'dispensing_records', 1, '{\"pharmacy_id\":1}', '2026-03-16 21:38:49'),
(6, 1, 'complete_prescription', 3, 'prescriptions', 1, '{\"status\":\"completed\"}', '2026-03-16 21:38:49'),
(7, 4, 'create_prescription', 1, 'prescriptions', 1, '{\"drug\": \"Amoxicillin 500mg\"}', '2026-03-24 10:55:02'),
(8, 4, 'create_prescription', 2, 'prescriptions', 1, '{\"drug\": \"Ibuprofen 200mg\"}', '2026-03-24 10:55:02'),
(9, 4, 'create_prescription', 3, 'prescriptions', 1, '{\"drug\": \"Paracetamol 500mg\"}', '2026-03-24 10:55:02'),
(10, 4, 'create_prescription', 4, 'prescriptions', 1, '{\"drug\": \"Atorvastatin 10mg\"}', '2026-03-24 10:55:02'),
(11, 4, 'create_prescription', 5, 'prescriptions', 1, '{\"drug\": \"Metformin 500mg\"}', '2026-03-24 10:55:02'),
(12, 4, 'create_prescription', 6, 'prescriptions', 1, '{\"drug\": \"Omeprazole 20mg\"}', '2026-03-24 10:55:02'),
(13, 5, 'create_prescription', 1, 'prescriptions', 1, '{\"drug\": \"Amoxicillin 500mg\"}', '2026-03-24 10:55:43'),
(14, 5, 'create_prescription', 2, 'prescriptions', 1, '{\"drug\": \"Ibuprofen 200mg\"}', '2026-03-24 10:55:43'),
(15, 5, 'create_prescription', 3, 'prescriptions', 1, '{\"drug\": \"Paracetamol 500mg\"}', '2026-03-24 10:55:43'),
(16, 5, 'create_prescription', 4, 'prescriptions', 1, '{\"drug\": \"Atorvastatin 10mg\"}', '2026-03-24 10:55:43'),
(17, 5, 'create_prescription', 5, 'prescriptions', 1, '{\"drug\": \"Metformin 500mg\"}', '2026-03-24 10:55:43'),
(18, 5, 'create_prescription', 6, 'prescriptions', 1, '{\"drug\": \"Omeprazole 20mg\"}', '2026-03-24 10:55:43'),
(19, 4, 'create_prescription', 1, 'prescriptions', 1, '{\"drug\": \"Amoxicillin 500mg\"}', '2026-03-24 21:47:35'),
(20, 4, 'create_prescription', 2, 'prescriptions', 1, '{\"drug\": \"Ibuprofen 200mg\"}', '2026-03-24 21:47:35'),
(21, 4, 'create_prescription', 3, 'prescriptions', 1, '{\"drug\": \"Paracetamol 500mg\"}', '2026-03-24 21:47:35'),
(22, 4, 'create_prescription', 4, 'prescriptions', 1, '{\"drug\": \"Atorvastatin 10mg\"}', '2026-03-24 21:47:35'),
(23, 4, 'create_prescription', 5, 'prescriptions', 1, '{\"drug\": \"Metformin 500mg\"}', '2026-03-24 21:47:35'),
(24, 4, 'create_prescription', 6, 'prescriptions', 1, '{\"drug\": \"Omeprazole 20mg\"}', '2026-03-24 21:47:35'),
(25, 4, NULL, 1, 'prescriptions', 1, '{\"drug\":\"A\"}', '2026-03-24 22:27:46'),
(26, 4, NULL, 2, 'prescriptions', 1, '{\"drug\":\"B\"}', '2026-03-24 22:27:46'),
(27, 4, NULL, 3, 'prescriptions', 1, '{\"drug\":\"C\"}', '2026-03-24 22:27:46'),
(28, 4, NULL, 4, 'prescriptions', 1, '{\"drug\":\"D\"}', '2026-03-24 22:27:46'),
(29, 4, NULL, 5, 'prescriptions', 1, '{\"drug\":\"E\"}', '2026-03-24 22:27:46'),
(30, 4, NULL, 6, 'prescriptions', 1, '{\"drug\":\"F\"}', '2026-03-24 22:27:46'),
(31, 4, NULL, 1, 'prescriptions', 1, '{\"drug\":\"Amoxicillin\"}', '2026-03-24 22:45:22'),
(32, 4, NULL, 2, 'prescriptions', 1, '{\"drug\":\"Ibuprofen\"}', '2026-03-24 22:45:22'),
(33, 4, NULL, 3, 'prescriptions', 1, '{\"drug\":\"Paracetamol\"}', '2026-03-24 22:45:22'),
(34, 4, NULL, 4, 'prescriptions', 1, '{\"drug\":\"Metformin\"}', '2026-03-24 22:45:22'),
(35, 4, NULL, 5, 'prescriptions', 1, '{\"drug\":\"Atorvastatin\"}', '2026-03-24 22:45:22'),
(36, 4, NULL, 6, 'prescriptions', 1, '{\"drug\":\"Omeprazole\"}', '2026-03-24 22:45:22'),
(37, 4, NULL, 1, 'prescriptions', 1, '{\"drug\":\"Amoxicillin\"}', '2026-03-24 22:50:15'),
(38, 4, NULL, 2, 'prescriptions', 1, '{\"drug\":\"Ibuprofen\"}', '2026-03-24 22:50:15'),
(39, 4, NULL, 3, 'prescriptions', 1, '{\"drug\":\"Paracetamol\"}', '2026-03-24 22:50:15'),
(40, 4, NULL, 4, 'prescriptions', 1, '{\"drug\":\"Metformin\"}', '2026-03-24 22:50:15'),
(41, 4, NULL, 5, 'prescriptions', 1, '{\"drug\":\"Atorvastatin\"}', '2026-03-24 22:50:15'),
(42, 4, NULL, 6, 'prescriptions', 1, '{\"drug\":\"Omeprazole\"}', '2026-03-24 22:50:15'),
(43, 6, NULL, 1, 'prescriptions', 1, '{\"drug\": \"paracetamol\"}', '2026-03-25 13:14:44'),
(44, 6, NULL, NULL, 'prescriptions', 1, '{\"drug\": \"painkiller\"}', '2026-03-25 20:26:50'),
(45, 6, NULL, 1, 'prescriptions', 1, '{\"drug\":\"napa\",\"dosage\":\"200gm\"}', '2026-03-25 20:44:15'),
(46, 7, NULL, 4, 'prescriptions', 1, '{\"drug\": \"antibiotic\", \"dosage\": \"300mg\", \"quantity\": \"2\"}', '2026-03-25 21:12:40'),
(47, 7, NULL, 1, 'prescriptions', 1, '{\"drug\": \"dolo\", \"dosage\": \"250mg\", \"quantity\": \"1\"}', '2026-03-26 00:27:03');

--
-- Triggers `blockchain_transactions`
--
DELIMITER $$
CREATE TRIGGER `prevent_delete_transactions` BEFORE DELETE ON `blockchain_transactions` FOR EACH ROW BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Deletion not allowed on transactions';
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `dispensing_records`
--

CREATE TABLE `dispensing_records` (
  `dispense_id` int(11) NOT NULL,
  `item_id` int(11) DEFAULT NULL,
  `pharmacist_id` int(11) DEFAULT NULL,
  `date_dispensed` timestamp NOT NULL DEFAULT current_timestamp(),
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dispensing_records`
--

INSERT INTO `dispensing_records` (`dispense_id`, `item_id`, `pharmacist_id`, `date_dispensed`, `notes`) VALUES
(2, 1, 4, '2026-03-16 19:54:59', 'Dispensed successfully');

-- --------------------------------------------------------

--
-- Table structure for table `doctor_specialities`
--

CREATE TABLE `doctor_specialities` (
  `speciality_id` int(11) NOT NULL,
  `speciality_name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `doctor_specialities`
--

INSERT INTO `doctor_specialities` (`speciality_id`, `speciality_name`, `description`) VALUES
(1, 'General Practice', 'Primary healthcare'),
(2, 'Cardiology', 'Heart and cardiovascular system'),
(3, 'Neurology', 'Brain and nervous system');

-- --------------------------------------------------------

--
-- Table structure for table `doctor_users`
--

CREATE TABLE `doctor_users` (
  `doctor_id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `license_number` varchar(50) NOT NULL,
  `speciality_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `doctor_users`
--

INSERT INTO `doctor_users` (`doctor_id`, `full_name`, `license_number`, `speciality_id`) VALUES
(2, 'Dr John Smith', 'DOC123', 1);

-- --------------------------------------------------------

--
-- Table structure for table `drug_categories`
--

CREATE TABLE `drug_categories` (
  `category_id` int(11) NOT NULL,
  `category_name` varchar(100) NOT NULL,
  `type` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `drug_categories`
--

INSERT INTO `drug_categories` (`category_id`, `category_name`, `type`) VALUES
(1, 'Antibiotics', 'controlled_substance'),
(2, 'Painkillers', 'over_the_counter'),
(3, 'Antivirals', 'controlled_substance');

-- --------------------------------------------------------

--
-- Table structure for table `drug_stock`
--

CREATE TABLE `drug_stock` (
  `stock_id` int(11) NOT NULL,
  `pharmacy_id` int(11) DEFAULT NULL,
  `drug_id` int(11) DEFAULT NULL,
  `quantity_available` int(11) DEFAULT 0,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `failed_logins`
--

CREATE TABLE `failed_logins` (
  `attempt_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `ip_address` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `failed_logins`
--

INSERT INTO `failed_logins` (`attempt_id`, `user_id`, `timestamp`, `ip_address`) VALUES
(4, NULL, '2026-03-26 00:16:53', NULL),
(5, NULL, '2026-03-26 00:34:30', NULL),
(6, NULL, '2026-03-26 00:34:42', NULL),
(7, NULL, '2026-03-26 00:42:41', NULL),
(8, 1, '2026-03-26 00:43:04', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `patient_users`
--

CREATE TABLE `patient_users` (
  `patient_id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `dob` date DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `emergency_contact` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `patient_users`
--

INSERT INTO `patient_users` (`patient_id`, `full_name`, `dob`, `address`, `emergency_contact`) VALUES
(5, 'Mark Taylor', '1998-05-14', 'London', '0700000000');

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `permission_id` int(11) NOT NULL,
  `permission_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `permissions`
--

INSERT INTO `permissions` (`permission_id`, `permission_name`) VALUES
(1, 'create_prescription'),
(3, 'dispense_medication'),
(4, 'manage_users'),
(5, 'view_own_records'),
(2, 'view_prescription');

-- --------------------------------------------------------

--
-- Table structure for table `pharmacies`
--

CREATE TABLE `pharmacies` (
  `pharmacy_id` int(11) NOT NULL,
  `pharmacy_name` varchar(100) NOT NULL,
  `location` varchar(255) DEFAULT NULL,
  `registration_id` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pharmacies`
--

INSERT INTO `pharmacies` (`pharmacy_id`, `pharmacy_name`, `location`, `registration_id`) VALUES
(1, 'City Health Pharmacy', 'London', 'PHARM001'),
(2, 'Green Cross Pharmacy', 'Manchester', 'PHARM002');

-- --------------------------------------------------------

--
-- Table structure for table `pharmacist_users`
--

CREATE TABLE `pharmacist_users` (
  `pharmacist_id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `pharmacy_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pharmacist_users`
--

INSERT INTO `pharmacist_users` (`pharmacist_id`, `full_name`, `pharmacy_id`) VALUES
(4, 'Alice Brown', 1);

-- --------------------------------------------------------

--
-- Table structure for table `prescriptions`
--

CREATE TABLE `prescriptions` (
  `prescription_id` int(11) NOT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `doctor_id` int(11) DEFAULT NULL,
  `date_issued` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('issued','dispensed','cancelled') DEFAULT 'issued'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `prescriptions`
--

INSERT INTO `prescriptions` (`prescription_id`, `patient_id`, `doctor_id`, `date_issued`, `status`) VALUES
(1, 5, 2, '2026-03-16 19:53:41', 'issued');

-- --------------------------------------------------------

--
-- Table structure for table `prescription_items`
--

CREATE TABLE `prescription_items` (
  `item_id` int(11) NOT NULL,
  `prescription_id` int(11) DEFAULT NULL,
  `drug_id` int(11) DEFAULT NULL,
  `dosage` varchar(100) DEFAULT NULL,
  `frequency` varchar(100) DEFAULT NULL,
  `instructions` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `prescription_items`
--

INSERT INTO `prescription_items` (`item_id`, `prescription_id`, `drug_id`, `dosage`, `frequency`, `instructions`) VALUES
(1, 1, 1, '500mg', 'Twice a day', 'After meals');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `role_id` int(11) NOT NULL,
  `role_name` enum('admin','doctor','pharmacist','patient') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`role_id`, `role_name`) VALUES
(1, 'admin'),
(2, 'doctor'),
(3, 'pharmacist'),
(4, 'patient');

-- --------------------------------------------------------

--
-- Table structure for table `role_permissions`
--

CREATE TABLE `role_permissions` (
  `role_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `role_permissions`
--

INSERT INTO `role_permissions` (`role_id`, `permission_id`) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(2, 1),
(2, 2),
(3, 2),
(3, 3),
(4, 2),
(4, 5);

-- --------------------------------------------------------

--
-- Table structure for table `security_audit_log`
--

CREATE TABLE `security_audit_log` (
  `audit_id` int(11) NOT NULL,
  `action_performed` varchar(100) NOT NULL,
  `performed_by` int(11) DEFAULT NULL,
  `status` varchar(20) NOT NULL,
  `remarks` text DEFAULT NULL,
  `action_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `security_audit_log`
--

INSERT INTO `security_audit_log` (`audit_id`, `action_performed`, `performed_by`, `status`, `remarks`, `action_time`) VALUES
(1, 'LOGIN_SUCCESS', 1, 'SUCCESS', 'Test login', '2026-03-25 23:23:02'),
(2, 'LOGIN_SUCCESS', 1, 'SUCCESS', 'User 1 successfully logged in', '2026-03-25 23:23:35'),
(3, 'LOGIN_SUCCESS', 1, 'SUCCESS', 'User 1 successfully logged in', '2026-03-25 23:24:21'),
(4, 'LOGOUT', 1, 'SUCCESS', 'User 1 logged out', '2026-03-25 23:24:36'),
(8, 'LOGIN_SUCCESS', 1, 'SUCCESS', 'User 1 successfully logged in', '2026-03-25 23:34:01'),
(9, 'LOGOUT', 1, 'SUCCESS', 'User 1 logged out', '2026-03-25 23:34:05'),
(13, 'LOGIN_SUCCESS', 1, 'SUCCESS', 'User 1 successfully logged in', '2026-03-26 00:06:08'),
(14, 'LOGOUT', 1, 'SUCCESS', 'User 1 logged out', '2026-03-26 00:06:16'),
(17, 'LOGIN_FAILED', NULL, 'FAILED', 'Failed login attempt with User ID: 55', '2026-03-26 00:16:53'),
(19, 'LOGIN_SUCCESS', 1, 'SUCCESS', 'User 1 successfully logged in', '2026-03-26 00:19:08'),
(20, 'LOGIN_SUCCESS', 2, 'SUCCESS', 'User 2 successfully logged in', '2026-03-26 00:19:27'),
(23, 'LOGIN_SUCCESS', 1, 'SUCCESS', 'User 1 successfully logged in', '2026-03-26 00:26:06'),
(24, 'APPLICATION_EXIT', 1, 'SUCCESS', 'User 1 exited application', '2026-03-26 00:28:42'),
(25, 'LOGIN_FAILED', NULL, 'FAILED', 'Failed login attempt with User ID: 555', '2026-03-26 00:34:30'),
(26, 'LOGIN_FAILED', NULL, 'FAILED', 'Failed login attempt with User ID: 888', '2026-03-26 00:34:42'),
(27, 'LOGIN_FAILED', NULL, 'FAILED', 'Failed login attempt with User ID: 55', '2026-03-26 00:42:41'),
(28, 'LOGIN_SUCCESS', 5, 'SUCCESS', 'User 5 successfully logged in', '2026-03-26 00:42:50'),
(29, 'APPLICATION_EXIT', 5, 'SUCCESS', 'User 5 exited application', '2026-03-26 00:42:52'),
(30, 'LOGIN_FAILED', 1, 'FAILED', 'Failed login attempt with User ID: 1', '2026-03-26 00:43:04'),
(31, 'LOGIN_SUCCESS', 1, 'SUCCESS', 'User 1 successfully logged in', '2026-03-26 01:19:44'),
(32, 'APPLICATION_EXIT', 1, 'SUCCESS', 'User 1 exited application', '2026-03-26 01:44:52'),
(33, 'LOGIN_SUCCESS', 1, 'SUCCESS', 'User 1 successfully logged in', '2026-03-26 02:01:23'),
(34, 'LOGIN_SUCCESS', 1, 'SUCCESS', 'User 1 successfully logged in', '2026-03-26 02:15:47'),
(35, 'LOGIN_SUCCESS', 1, 'SUCCESS', 'User 1 successfully logged in', '2026-03-26 02:20:04'),
(36, 'LOGOUT', 1, 'SUCCESS', 'User 1 logged out', '2026-03-26 02:22:29'),
(0, 'LOGIN_SUCCESS', 5, 'SUCCESS', 'User 5 successfully logged in', '2026-03-26 16:18:17');

-- --------------------------------------------------------

--
-- Table structure for table `system_notifications`
--

CREATE TABLE `system_notifications` (
  `notification_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `read_status` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `system_notifications`
--

INSERT INTO `system_notifications` (`notification_id`, `user_id`, `message`, `read_status`, `created_at`) VALUES
(1, 1, 'Test notification', 0, '2026-03-25 23:23:02'),
(2, 1, 'Welcome back!', 0, '2026-03-25 23:23:35'),
(3, 1, 'Welcome back!', 0, '2026-03-25 23:24:21'),
(4, 1, 'You have been logged out', 0, '2026-03-25 23:24:36'),
(5, 1, 'Welcome back!', 0, '2026-03-25 23:34:01'),
(6, 1, 'You have been logged out', 0, '2026-03-25 23:34:05'),
(7, 1, 'Welcome back!', 0, '2026-03-26 00:06:08'),
(8, 1, 'You have been logged out', 0, '2026-03-26 00:06:16'),
(9, NULL, 'Failed login attempt detected', 0, '2026-03-26 00:16:53'),
(11, 1, 'Welcome back!', 0, '2026-03-26 00:19:08'),
(12, 2, 'Welcome back!', 0, '2026-03-26 00:19:27'),
(14, 1, 'Welcome back!', 0, '2026-03-26 00:26:06'),
(15, NULL, 'Failed login attempt detected', 0, '2026-03-26 00:34:30'),
(16, NULL, 'Failed login attempt detected', 0, '2026-03-26 00:34:42'),
(17, NULL, 'Failed login attempt detected', 0, '2026-03-26 00:42:41'),
(18, 5, 'Welcome back!', 0, '2026-03-26 00:42:50'),
(19, NULL, 'Failed login attempt detected', 0, '2026-03-26 00:43:04'),
(20, 1, 'Welcome back!', 0, '2026-03-26 01:19:44'),
(21, 1, 'Welcome back!', 0, '2026-03-26 02:01:23'),
(22, 1, 'Welcome back!', 0, '2026-03-26 02:15:47'),
(23, 1, 'Welcome back!', 0, '2026-03-26 02:20:04'),
(24, 1, 'You have been logged out', 0, '2026-03-26 02:22:29'),
(0, 5, 'Welcome back!', 0, '2026-03-26 16:18:17');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `role` enum('admin','doctor','pharmacist','patient') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `role_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `password_hash`, `email`, `phone`, `role`, `created_at`, `role_id`) VALUES
(1, 'admin1', 'password@123', 'admin@test.com', NULL, 'admin', '2026-03-16 19:39:36', NULL),
(2, 'doctor1', 'password@123', 'doctor@test.com', NULL, 'doctor', '2026-03-16 19:39:52', NULL),
(4, 'pharm1', 'password@123', 'pharm@test.com', NULL, 'pharmacist', '2026-03-16 19:40:47', NULL),
(5, 'patient1', 'password@123', 'patient@test.com', NULL, 'patient', '2026-03-16 19:41:07', NULL),
(7, 'doctor2', 'hashed_pw', '', NULL, 'admin', '2026-03-16 21:18:16', 2);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_audit_monitoring`
-- (See below for the actual view)
--
CREATE TABLE `vw_audit_monitoring` (
`log_id` int(11)
,`user_id` int(11)
,`action` varchar(100)
,`target_table` varchar(100)
,`target_id` int(11)
,`timestamp` timestamp
);

-- --------------------------------------------------------

--
-- Table structure for table `vw_block_summary`
--

CREATE TABLE `vw_block_summary` (
  `block_id` int(11) DEFAULT NULL,
  `total_transactions` bigint(21) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `vw_block_transaction_summary`
--

CREATE TABLE `vw_block_transaction_summary` (
  `block_id` int(11) DEFAULT NULL,
  `total_transactions` bigint(21) DEFAULT NULL,
  `is_sealed` tinyint(1) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `vw_chain_validation`
--

CREATE TABLE `vw_chain_validation` (
  `block_id` int(11) DEFAULT NULL,
  `previous_hash` char(64) DEFAULT NULL,
  `expected_previous_hash` char(64) DEFAULT NULL,
  `chain_status` varchar(7) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Structure for view `vw_audit_monitoring`
--
DROP TABLE IF EXISTS `vw_audit_monitoring`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_audit_monitoring`  AS SELECT `audit_log`.`log_id` AS `log_id`, `audit_log`.`user_id` AS `user_id`, `audit_log`.`action` AS `action`, `audit_log`.`target_table` AS `target_table`, `audit_log`.`target_id` AS `target_id`, `audit_log`.`timestamp` AS `timestamp` FROM `audit_log` ORDER BY `audit_log`.`timestamp` DESC ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
