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
-- Table structure for table `blood_unit_tobedonated`
--

DROP TABLE IF EXISTS `blood_unit_tobedonated`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blood_unit_tobedonated` (
  `blood_ID` int NOT NULL AUTO_INCREMENT,
  `blood_type` enum('A','B','AB','O') NOT NULL,
  `rhesus` enum('+','-') NOT NULL,
  `donor_ID` int NOT NULL,
  `recipient_ID` int NOT NULL,
  `branch_ID` int NOT NULL,
  PRIMARY KEY (`blood_ID`),
  KEY `donor_ID` (`donor_ID`),
  KEY `recipient_ID` (`recipient_ID`),
  KEY `branch_ID` (`branch_ID`),
  CONSTRAINT `blood_unit_tobedonated_ibfk_1` FOREIGN KEY (`donor_ID`) REFERENCES `donor` (`donor_ID`) ON DELETE CASCADE,
  CONSTRAINT `blood_unit_tobedonated_ibfk_2` FOREIGN KEY (`recipient_ID`) REFERENCES `recipient` (`recipient_ID`) ON DELETE CASCADE,
  CONSTRAINT `blood_unit_tobedonated_ibfk_3` FOREIGN KEY (`branch_ID`) REFERENCES `branch` (`branch_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blood_unit_tobedonated`
--

LOCK TABLES `blood_unit_tobedonated` WRITE;
/*!40000 ALTER TABLE `blood_unit_tobedonated` DISABLE KEYS */;
/*!40000 ALTER TABLE `blood_unit_tobedonated` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-12-20 12:37:03
