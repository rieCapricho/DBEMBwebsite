-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 09, 2025 at 10:34 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cirva_database`
--

-- --------------------------------------------------------

--
-- Table structure for table `attendance`
--

CREATE TABLE `attendance` (
  `AttendanceID` int(11) NOT NULL,
  `NumberOfMembers` int(11) NOT NULL,
  `EventTypeID` int(11) NOT NULL,
  `date` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `attendance`
--

INSERT INTO `attendance` (`AttendanceID`, `NumberOfMembers`, `EventTypeID`, `date`) VALUES
(1, 10, 1, '2024-03-01'),
(2, 15, 2, '2024-03-02'),
(3, 20, 3, '2024-03-03'),
(4, 12, 4, '2024-03-04'),
(5, 18, 5, '2024-03-05'),
(6, 25, 6, '2024-03-06'),
(7, 30, 7, '2024-03-07'),
(8, 22, 8, '2024-03-08'),
(9, 16, 9, '2024-03-09'),
(10, 28, 10, '2024-03-10'),
(11, 14, 11, '2024-03-11'),
(12, 19, 12, '2024-03-12'),
(13, 21, 13, '2024-03-13'),
(14, 26, 14, '2024-03-14'),
(15, 32, 15, '2024-03-15'),
(16, 17, 16, '2024-03-16'),
(17, 23, 17, '2024-03-17'),
(18, 27, 18, '2024-03-18'),
(19, 29, 19, '2024-03-19'),
(21, 29, 19, '2024-03-19'),
(22, 31, 20, '2024-03-20');

-- --------------------------------------------------------

--
-- Table structure for table `eventtype`
--

CREATE TABLE `eventtype` (
  `EventTypeID` int(11) NOT NULL,
  `EventName` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `eventtype`
--

INSERT INTO `eventtype` (`EventTypeID`, `EventName`) VALUES
(1, 'Concert'),
(2, 'Wedding'),
(3, 'Corporate Event'),
(4, 'Birthday Party'),
(5, 'Festival'),
(6, 'Charity Event'),
(7, 'Music Competition'),
(8, 'School Event'),
(9, 'Religious Event'),
(10, 'Private Gathering'),
(11, 'Product Launch'),
(12, 'Fundraising Event'),
(13, 'Sports Event'),
(14, 'Award Ceremony'),
(15, 'Public Performance'),
(16, 'Anniversary Celebration'),
(17, 'Cultural Night'),
(18, 'Club Event'),
(19, 'Networking Event'),
(20, 'Community Event');

-- --------------------------------------------------------

--
-- Table structure for table `expenses`
--

CREATE TABLE `expenses` (
  `ExpenseID` int(11) NOT NULL,
  `DateEncoded` date NOT NULL,
  `Description` varchar(255) DEFAULT NULL,
  `Amount` decimal(10,2) NOT NULL,
  `DateUsed` date DEFAULT NULL,
  `AmountGiven` decimal(10,2) DEFAULT NULL,
  `DateGiven` date DEFAULT NULL,
  `PersonID` int(11) DEFAULT NULL,
  `OfficerID` int(11) DEFAULT NULL,
  `Invoice` longblob DEFAULT NULL,
  `KeeperID` int(11) DEFAULT NULL,
  `EventTypeID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `expenses`
--

INSERT INTO `expenses` (`ExpenseID`, `DateEncoded`, `Description`, `Amount`, `DateUsed`, `AmountGiven`, `DateGiven`, `PersonID`, `OfficerID`, `Invoice`, `KeeperID`, `EventTypeID`) VALUES
(1, '2025-03-01', 'Food', 500.00, '2025-03-01', 400.00, '2025-03-01', 1, 1, NULL, 1, 1),
(2, '2025-03-02', 'Transport', 300.00, '2025-03-02', 250.00, '2025-03-02', 2, 2, NULL, 2, 2),
(3, '2025-03-03', 'Equipment', 700.00, '2025-03-03', 650.00, '2025-03-03', 3, 3, NULL, 3, 3),
(4, '2025-03-04', 'Decorations', 100.00, '2025-03-04', 80.00, '2025-03-04', 4, 4, NULL, 4, 4),
(5, '2025-03-05', 'Venue', 1500.00, '2025-03-05', 1400.00, '2025-03-05', 5, 5, NULL, 5, 5),
(6, '2025-03-06', 'Security', 200.00, '2025-03-06', 180.00, '2025-03-06', 6, 6, NULL, 6, 6),
(7, '2025-03-07', 'Staff', 300.00, '2025-03-07', 250.00, '2025-03-07', 7, 7, NULL, 7, 7),
(8, '2025-03-08', 'Transportation', 450.00, '2025-03-08', 400.00, '2025-03-08', 8, 8, NULL, 8, 8),
(9, '2025-03-09', 'Miscellaneous', 600.00, '2025-03-09', 550.00, '2025-03-09', 9, 9, NULL, 9, 9),
(10, '2025-03-10', 'Food', 500.00, '2025-03-10', 450.00, '2025-03-10', 10, 10, NULL, 10, 10),
(11, '2025-03-11', 'Decorations', 300.00, '2025-03-11', 280.00, '2025-03-11', 11, 11, NULL, 11, 11),
(12, '2025-03-12', 'Security', 250.00, '2025-03-12', 230.00, '2025-03-12', 12, 12, NULL, 12, 12),
(13, '2025-03-13', 'Venue', 1200.00, '2025-03-13', 1100.00, '2025-03-13', 13, 13, NULL, 13, 13),
(14, '2025-03-14', 'Transportation', 400.00, '2025-03-14', 370.00, '2025-03-14', 14, 14, NULL, 14, 14),
(15, '2025-03-15', 'Staff', 250.00, '2025-03-15', 230.00, '2025-03-15', 15, 15, NULL, 15, 15),
(16, '2025-03-16', 'Miscellaneous', 550.00, '2025-03-16', 520.00, '2025-03-16', 16, 16, NULL, 16, 16),
(17, '2025-03-17', 'Equipment', 650.00, '2025-03-17', 600.00, '2025-03-17', 17, 17, NULL, 17, 17),
(18, '2025-03-18', 'Food', 300.00, '2025-03-18', 280.00, '2025-03-18', 18, 18, NULL, 18, 18),
(19, '2025-03-19', 'Decorations', 200.00, '2025-03-19', 180.00, '2025-03-19', 19, 19, NULL, 19, 19),
(20, '2025-03-20', 'Security', 250.00, '2025-03-20', 230.00, '2025-03-20', 20, 20, NULL, 20, 20);

-- --------------------------------------------------------

--
-- Table structure for table `incharge`
--

CREATE TABLE `incharge` (
  `InchargeID` int(11) NOT NULL,
  `PersonID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `incharge`
--

INSERT INTO `incharge` (`InchargeID`, `PersonID`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10),
(11, 11),
(12, 12),
(13, 13),
(14, 14),
(15, 15),
(16, 16),
(17, 17),
(18, 18),
(19, 19),
(20, 20),
(25, 25);

-- --------------------------------------------------------

--
-- Table structure for table `login`
--

CREATE TABLE `login` (
  `LoginID` int(11) NOT NULL,
  `OfficerID` int(11) DEFAULT NULL,
  `Username` varchar(255) NOT NULL,
  `Password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `login`
--

INSERT INTO `login` (`LoginID`, `OfficerID`, `Username`, `Password`) VALUES
(1, 1, 'user1', 'password1'),
(2, 2, 'user2', 'password2'),
(3, 3, 'user3', 'password3'),
(4, 4, 'user4', 'password4'),
(5, 5, 'user5', 'password5'),
(6, 6, 'user6', 'password6'),
(7, 7, 'user7', 'password7'),
(8, 8, 'user8', 'password8'),
(9, 9, 'user9', 'password9'),
(10, 10, 'user10', 'password10'),
(11, 11, 'user11', 'password11'),
(12, 12, 'user12', 'password12'),
(13, 13, 'user13', 'password13'),
(14, 14, 'user14', 'password14'),
(15, 15, 'user15', 'password15'),
(16, 16, 'user16', 'password16'),
(17, 17, 'user17', 'password17'),
(18, 18, 'user18', 'password18'),
(19, 19, 'user19', 'password19'),
(20, 20, 'user20', 'password20'),
(25, 25, 'new', '$2b$10$R2wuz3cyqauZ5YrWP5ocFO3/VwIt4Qtff26pVTeCsgSyKKwJDP4zC');

-- --------------------------------------------------------

--
-- Table structure for table `officer`
--

CREATE TABLE `officer` (
  `OfficerID` int(11) NOT NULL,
  `PersonID` int(11) DEFAULT NULL,
  `RoleDescription` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `officer`
--

INSERT INTO `officer` (`OfficerID`, `PersonID`, `RoleDescription`) VALUES
(1, 1, 'Manager'),
(2, 2, 'Assistant'),
(3, 3, 'Coordinator'),
(4, 4, 'Supervisor'),
(5, 5, 'Administrator'),
(6, 6, 'Secretary'),
(7, 7, 'Lead'),
(8, 8, 'Officer'),
(9, 9, 'Director'),
(10, 10, 'Assistant'),
(11, 11, 'Manager'),
(12, 12, 'Coordinator'),
(13, 13, 'Supervisor'),
(14, 14, 'Lead'),
(15, 15, 'Secretary'),
(16, 16, 'Administrator'),
(17, 17, 'Officer'),
(18, 18, 'Director'),
(19, 19, 'Assistant'),
(20, 20, 'Coordinator'),
(25, 25, 'new');

-- --------------------------------------------------------

--
-- Table structure for table `payment`
--

CREATE TABLE `payment` (
  `PaymentID` int(11) NOT NULL,
  `RevenueID` int(11) DEFAULT NULL,
  `PaymentDate` date NOT NULL,
  `ModeOfPayment` enum('Cash','Gcash','Bank') NOT NULL,
  `AmountPaid` decimal(10,2) NOT NULL,
  `Remarks` enum('Full','Not Full') NOT NULL,
  `Balance` decimal(10,2) DEFAULT NULL,
  `DateReceived` date DEFAULT NULL,
  `OfficerID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payment`
--

INSERT INTO `payment` (`PaymentID`, `RevenueID`, `PaymentDate`, `ModeOfPayment`, `AmountPaid`, `Remarks`, `Balance`, `DateReceived`, `OfficerID`) VALUES
(1, 1, '2025-03-01', 'Cash', 5000.00, 'Full', 0.00, '2025-03-01', 1),
(2, 2, '2025-03-02', 'Gcash', 3000.00, 'Not Full', 500.00, '2025-03-02', 2),
(3, 3, '2025-03-03', 'Bank', 4500.00, 'Full', 0.00, '2025-03-03', 3),
(4, 4, '2025-03-04', 'Cash', 6000.00, 'Not Full', 1000.00, '2025-03-04', 4),
(5, 5, '2025-03-05', 'Gcash', 3500.00, 'Full', 0.00, '2025-03-05', 5),
(6, 6, '2025-03-06', 'Bank', 4000.00, 'Full', 0.00, '2025-03-06', 6),
(7, 7, '2025-03-07', 'Cash', 5200.00, 'Not Full', 400.00, '2025-03-07', 1),
(8, 8, '2025-03-08', 'Gcash', 3100.00, 'Full', 0.00, '2025-03-08', 2),
(10, 10, '2025-03-10', 'Cash', 6200.00, 'Full', 0.00, '2025-03-10', 4),
(11, 11, '2025-03-11', 'Gcash', 3600.00, 'Not Full', 400.00, '2025-03-11', 5),
(12, 12, '2025-03-12', 'Bank', 4100.00, 'Full', 0.00, '2025-03-12', 6),
(13, 13, '2025-03-13', 'Cash', 5300.00, 'Not Full', 200.00, '2025-03-13', 1),
(14, 14, '2025-03-14', 'Gcash', 3200.00, 'Full', 0.00, '2025-03-14', 2),
(16, 16, '2025-03-16', 'Cash', 6300.00, 'Full', 0.00, '2025-03-16', 4),
(17, 17, '2025-03-17', 'Gcash', 3700.00, 'Not Full', 500.00, '2025-03-17', 5),
(18, 18, '2025-03-18', 'Bank', 4200.00, 'Full', 0.00, '2025-03-18', 6);

-- --------------------------------------------------------

--
-- Table structure for table `person`
--

CREATE TABLE `person` (
  `PersonID` int(11) NOT NULL,
  `FirstName` varchar(50) NOT NULL,
  `LastName` varchar(50) NOT NULL,
  `ContactNumber` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `person`
--

INSERT INTO `person` (`PersonID`, `FirstName`, `LastName`, `ContactNumber`) VALUES
(1, 'John', 'Doe', '09123456789'),
(2, 'Jane', 'Smith', '09234567890'),
(3, 'Michael', 'Johnson', '09345678901'),
(4, 'Emily', 'Williams', '09456789012'),
(5, 'David', 'Brown', '09567890123'),
(6, 'Sarah', 'Jones', '09678901234'),
(7, 'James', 'Miller', '09789012345'),
(8, 'Laura', 'Davis', '09890123456'),
(9, 'Robert', 'Garcia', '09901234567'),
(10, 'Linda', 'Martinez', '09112345678'),
(11, 'Thomas', 'Rodriguez', '09223456789'),
(12, 'Jessica', 'Wilson', '09334567890'),
(13, 'William', 'Taylor', '09445678901'),
(14, 'Patricia', 'Anderson', '09556789012'),
(15, 'Charles', 'Thomas', '09667890123'),
(16, 'Elizabeth', 'Jackson', '09778901234'),
(17, 'Daniel', 'White', '09889012345'),
(18, 'Helen', 'Harris', '09990123456'),
(19, 'Christopher', 'Martin', '09101234567'),
(20, 'Nancy', 'Lee', '09212345678'),
(25, 'New', 'new', '2');

-- --------------------------------------------------------

--
-- Table structure for table `recordkeeper`
--

CREATE TABLE `recordkeeper` (
  `KeeperID` int(11) NOT NULL,
  `PersonID` int(11) DEFAULT NULL,
  `OfficerID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `recordkeeper`
--

INSERT INTO `recordkeeper` (`KeeperID`, `PersonID`, `OfficerID`) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5),
(6, 6, 6),
(7, 7, 7),
(8, 8, 8),
(9, 9, 9),
(10, 10, 10),
(11, 11, 11),
(12, 12, 12),
(13, 13, 13),
(14, 14, 14),
(15, 15, 15),
(16, 16, 16),
(17, 17, 17),
(18, 18, 18),
(19, 19, 19),
(20, 20, 20),
(25, 25, 25);

-- --------------------------------------------------------

--
-- Table structure for table `revenues`
--

CREATE TABLE `revenues` (
  `RevenueID` int(11) NOT NULL,
  `EventDate` date NOT NULL,
  `EventTypeID` int(11) DEFAULT NULL,
  `Description` varchar(255) DEFAULT NULL,
  `InchargeID` int(11) DEFAULT NULL,
  `AmountGiven` decimal(10,2) NOT NULL,
  `BandShare` decimal(10,2) DEFAULT NULL,
  `MembersTalentFee` decimal(10,2) DEFAULT NULL,
  `KeeperID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `revenues`
--

INSERT INTO `revenues` (`RevenueID`, `EventDate`, `EventTypeID`, `Description`, `InchargeID`, `AmountGiven`, `BandShare`, `MembersTalentFee`, `KeeperID`) VALUES
(1, '2025-03-01', 1, 'Concert A', 1, 5000.00, 2000.00, 1000.00, 1),
(2, '2025-03-02', 2, 'Event B', 2, 3000.00, 1200.00, 600.00, 2),
(3, '2025-03-03', 3, 'Wedding C', 3, 4500.00, 1800.00, 900.00, 3),
(4, '2025-03-04', 1, 'Festival D', 4, 6000.00, 2400.00, 1200.00, 4),
(5, '2025-03-05', 2, 'Birthday E', 5, 3500.00, 1400.00, 700.00, 5),
(6, '2025-03-06', 3, 'Corporate F', 6, 4000.00, 1600.00, 800.00, 6),
(7, '2025-03-07', 1, 'Concert G', 1, 5200.00, 2080.00, 1040.00, 1),
(8, '2025-03-08', 2, 'Event H', 2, 3100.00, 1240.00, 620.00, 2),
(10, '2025-03-10', 1, 'Festival J', 4, 6200.00, 2480.00, 1240.00, 4),
(11, '2025-03-11', 2, 'Birthday K', 5, 3600.00, 1440.00, 720.00, 5),
(12, '2025-03-12', 3, 'Corporate L', 6, 4100.00, 1640.00, 820.00, 6),
(13, '2025-03-13', 1, 'Concert M', 1, 5300.00, 2120.00, 1060.00, 1),
(14, '2025-03-14', 2, 'Event N', 2, 3200.00, 1280.00, 640.00, 2),
(16, '2025-03-16', 1, 'Festival P', 4, 6300.00, 2520.00, 1260.00, 4),
(17, '2025-03-17', 2, 'Birthday Q', 5, 3700.00, 1480.00, 740.00, 5),
(18, '2025-03-21', 20, 'Corporate R', 7, 100.00, 100.00, 100.00, 14);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `attendance`
--
ALTER TABLE `attendance`
  ADD PRIMARY KEY (`AttendanceID`),
  ADD KEY `EventTypeID` (`EventTypeID`);

--
-- Indexes for table `eventtype`
--
ALTER TABLE `eventtype`
  ADD PRIMARY KEY (`EventTypeID`);

--
-- Indexes for table `expenses`
--
ALTER TABLE `expenses`
  ADD PRIMARY KEY (`ExpenseID`),
  ADD KEY `PersonID` (`PersonID`),
  ADD KEY `OfficerID` (`OfficerID`),
  ADD KEY `KeeperID` (`KeeperID`),
  ADD KEY `fk_EventType` (`EventTypeID`);

--
-- Indexes for table `incharge`
--
ALTER TABLE `incharge`
  ADD PRIMARY KEY (`InchargeID`),
  ADD KEY `PersonID` (`PersonID`);

--
-- Indexes for table `login`
--
ALTER TABLE `login`
  ADD PRIMARY KEY (`LoginID`),
  ADD KEY `OfficerID` (`OfficerID`);

--
-- Indexes for table `officer`
--
ALTER TABLE `officer`
  ADD PRIMARY KEY (`OfficerID`),
  ADD KEY `PersonID` (`PersonID`);

--
-- Indexes for table `payment`
--
ALTER TABLE `payment`
  ADD PRIMARY KEY (`PaymentID`),
  ADD KEY `RevenueID` (`RevenueID`),
  ADD KEY `OfficerID` (`OfficerID`);

--
-- Indexes for table `person`
--
ALTER TABLE `person`
  ADD PRIMARY KEY (`PersonID`);

--
-- Indexes for table `recordkeeper`
--
ALTER TABLE `recordkeeper`
  ADD PRIMARY KEY (`KeeperID`),
  ADD KEY `PersonID` (`PersonID`),
  ADD KEY `OfficerID` (`OfficerID`);

--
-- Indexes for table `revenues`
--
ALTER TABLE `revenues`
  ADD PRIMARY KEY (`RevenueID`),
  ADD KEY `EventTypeID` (`EventTypeID`),
  ADD KEY `InchargeID` (`InchargeID`),
  ADD KEY `KeeperID` (`KeeperID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `attendance`
--
ALTER TABLE `attendance`
  MODIFY `AttendanceID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `eventtype`
--
ALTER TABLE `eventtype`
  MODIFY `EventTypeID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `expenses`
--
ALTER TABLE `expenses`
  MODIFY `ExpenseID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `incharge`
--
ALTER TABLE `incharge`
  MODIFY `InchargeID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `login`
--
ALTER TABLE `login`
  MODIFY `LoginID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `officer`
--
ALTER TABLE `officer`
  MODIFY `OfficerID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `payment`
--
ALTER TABLE `payment`
  MODIFY `PaymentID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `person`
--
ALTER TABLE `person`
  MODIFY `PersonID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `recordkeeper`
--
ALTER TABLE `recordkeeper`
  MODIFY `KeeperID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `revenues`
--
ALTER TABLE `revenues`
  MODIFY `RevenueID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `attendance`
--
ALTER TABLE `attendance`
  ADD CONSTRAINT `attendance_ibfk_1` FOREIGN KEY (`EventTypeID`) REFERENCES `eventtype` (`EventTypeID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `expenses`
--
ALTER TABLE `expenses`
  ADD CONSTRAINT `expenses_ibfk_2` FOREIGN KEY (`PersonID`) REFERENCES `person` (`PersonID`),
  ADD CONSTRAINT `expenses_ibfk_3` FOREIGN KEY (`OfficerID`) REFERENCES `officer` (`OfficerID`),
  ADD CONSTRAINT `expenses_ibfk_4` FOREIGN KEY (`KeeperID`) REFERENCES `recordkeeper` (`KeeperID`),
  ADD CONSTRAINT `fk_EventType` FOREIGN KEY (`EventTypeID`) REFERENCES `eventtype` (`EventTypeID`);

--
-- Constraints for table `incharge`
--
ALTER TABLE `incharge`
  ADD CONSTRAINT `incharge_ibfk_1` FOREIGN KEY (`PersonID`) REFERENCES `person` (`PersonID`);

--
-- Constraints for table `login`
--
ALTER TABLE `login`
  ADD CONSTRAINT `login_ibfk_1` FOREIGN KEY (`OfficerID`) REFERENCES `officer` (`OfficerID`);

--
-- Constraints for table `officer`
--
ALTER TABLE `officer`
  ADD CONSTRAINT `officer_ibfk_1` FOREIGN KEY (`PersonID`) REFERENCES `person` (`PersonID`);

--
-- Constraints for table `payment`
--
ALTER TABLE `payment`
  ADD CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`RevenueID`) REFERENCES `revenues` (`RevenueID`),
  ADD CONSTRAINT `payment_ibfk_2` FOREIGN KEY (`OfficerID`) REFERENCES `officer` (`OfficerID`);

--
-- Constraints for table `recordkeeper`
--
ALTER TABLE `recordkeeper`
  ADD CONSTRAINT `recordkeeper_ibfk_1` FOREIGN KEY (`PersonID`) REFERENCES `person` (`PersonID`),
  ADD CONSTRAINT `recordkeeper_ibfk_2` FOREIGN KEY (`OfficerID`) REFERENCES `officer` (`OfficerID`);

--
-- Constraints for table `revenues`
--
ALTER TABLE `revenues`
  ADD CONSTRAINT `revenues_ibfk_1` FOREIGN KEY (`EventTypeID`) REFERENCES `eventtype` (`EventTypeID`),
  ADD CONSTRAINT `revenues_ibfk_2` FOREIGN KEY (`InchargeID`) REFERENCES `incharge` (`InchargeID`),
  ADD CONSTRAINT `revenues_ibfk_3` FOREIGN KEY (`KeeperID`) REFERENCES `recordkeeper` (`KeeperID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
