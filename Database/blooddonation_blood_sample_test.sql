-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: localhost    Database: blooddonation
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `blood_sample_test`
--

DROP TABLE IF EXISTS `blood_sample_test`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blood_sample_test` (
  `blood_Test_ID` int NOT NULL AUTO_INCREMENT,
  `appointment_Date` date NOT NULL,
  `sobriety` enum('yes','no') NOT NULL,
  `last_Donated_Date` date DEFAULT NULL,
  `disease` varchar(255) DEFAULT NULL,
  `hemoglobin` float NOT NULL,
  `iron_levels` float NOT NULL,
  `isQualified` enum('yes','no') NOT NULL,
  `donor_ID` int DEFAULT NULL,
  `blood_ID` int,
  PRIMARY KEY (`blood_Test_ID`),
  KEY `donor_ID` (`donor_ID`),
  CONSTRAINT `blood_sample_test_ibfk_1` FOREIGN KEY (`donor_ID`) REFERENCES `donor` (`donor_ID`) ON DELETE CASCADE,
  CONSTRAINT `blood_sample_test_chk_1` CHECK ((`bMI` > 0)),
  CONSTRAINT `blood_sample_test_chk_2` CHECK ((`hemoglobin` > 0)),
  CONSTRAINT `blood_sample_test_chk_3` CHECK ((`iron_levels` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blood_sample_test`
--

LOCK TABLES `blood_sample_test` WRITE;
/*!40000 ALTER TABLE `blood_sample_test` DISABLE KEYS */;
/*!40000 ALTER TABLE `blood_sample_test` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-12-20 12:37:02
