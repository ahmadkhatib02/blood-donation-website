CREATE DATABASE  IF NOT EXISTS `blooddonation` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `blooddonation`;
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
-- Table structure for table `appointment`
--

DROP TABLE IF EXISTS `appointment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appointment` (
  `apt_id` int NOT NULL,
  `apt_date` datetime DEFAULT NULL,
  `donor_id` int DEFAULT NULL,
  `branch_id` int DEFAULT NULL,
  `blood_id` int DEFAULT NULL,
  PRIMARY KEY (`apt_id`),
  KEY `donor_id` (`donor_id`),
  KEY `branch_id` (`branch_id`),
  KEY `blood_id` (`blood_id`),
  CONSTRAINT `appointment_ibfk_1` FOREIGN KEY (`donor_id`) REFERENCES `donor` (`donor_ID`),
  CONSTRAINT `appointment_ibfk_2` FOREIGN KEY (`branch_id`) REFERENCES `branch` (`branch_ID`),
  CONSTRAINT `appointment_ibfk_3` FOREIGN KEY (`blood_id`) REFERENCES `blood_unit_tobedonated` (`blood_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointment`
--

LOCK TABLES `appointment` WRITE;
/*!40000 ALTER TABLE `appointment` DISABLE KEYS */;
/*!40000 ALTER TABLE `appointment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blood_unit_tobedonated`
--

DROP TABLE IF EXISTS `blood_unit_tobedonated`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blood_unit_tobedonated` (
  `blood_ID` int NOT NULL AUTO_INCREMENT,
  `blood_type` enum('A','B','AB','O') DEFAULT NULL,
  `rhesus` enum('+','-') DEFAULT NULL,
  PRIMARY KEY (`blood_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blood_unit_tobedonated`
--

LOCK TABLES `blood_unit_tobedonated` WRITE;
/*!40000 ALTER TABLE `blood_unit_tobedonated` DISABLE KEYS */;
/*!40000 ALTER TABLE `blood_unit_tobedonated` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `branch`
--

DROP TABLE IF EXISTS `branch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `branch` (
  `branch_ID` int NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `phoneNumber` varchar(20) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `street` varchar(100) DEFAULT NULL,
  `type` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`branch_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `branch`
--

LOCK TABLES `branch` WRITE;
/*!40000 ALTER TABLE `branch` DISABLE KEYS */;
INSERT INTO `branch` VALUES (1,'Lebanese Red Cross Blood Donation Center - Spears','01 368 681','Beirut','Spears Street, Kantari','R'),(2,'Lebanese Red Cross Blood Donation Center - Gemmayze','01 444 102','Beirut','Gouraud Street, Gemmayze','R'),(3,'Lebanese Red Cross Blood Donation Center - Antelias','04 524 164','Antelias','Main Street, Antelias','R'),(4,'Lebanese Red Cross Blood Donation Center - Jounieh','09 930 488','Jounieh','Near Fouad Chehab Stadium','R'),(5,'Lebanese Red Cross Blood Donation Center - Jbeil','09 945 220','Jbeil','Facing the Municipality','R'),(6,'Lebanese Red Cross Blood Donation Center - Tripoli','06 601 429','Tripoli','Dam w Farez Street','R'),(7,'Lebanese Red Cross Blood Donation Center - Halba','06 695 370','Halba','Main Road, Halba','R'),(8,'Lebanese Red Cross Blood Donation Center - Zahle','08 804 930','Zahle','Brazil Street','R'),(9,'Lebanese Red Cross Blood Donation Center - Beit Eddine','03 468 728','Beit Eddine','Main Road, Beit Eddine','R'),(10,'Lebanese Red Cross Blood Donation Center - Saida','07 752 141','Saida','Riad El Solh Street','R'),(11,'Lebanese Red Cross Blood Donation Center - Nabatieh','07 768 687','Nabatieh','Nabatieh Main Road','R'),(12,'Lebanese Red Cross Blood Donation Center - Tyre','07 351 370','Tyre','Jall Al Bahr Street','R'),(13,'Lebanese Red Cross Blood Donation Center - Rachaya','08 595 789','Rachaya','Main Road, Rachaya','R'),(14,'American University of Beirut Medical Center (AUBMC)','01 350 000','Beirut','Cairo Street, Hamra','H'),(15,'Al Zahraa Hospital University Medical Center','01 822 610','Beirut','Airport Road, Bir Hassan','H'),(16,'Saint George Hospital University Medical Center','01 441 000','Beirut','Ashrafieh, Beirut','H'),(17,'Hôtel-Dieu de France','01 615 300','Beirut','Alfred Naccache Street, Achrafieh','H'),(18,'Makassed General Hospital','01 370 555','Beirut','Tarik El Jdideh','H'),(19,'Lebanese Hospital Geitaoui','01 590 000','Beirut','Achrafieh, Beirut','H'),(20,'Nini Hospital','06 430 430','Tripoli','Riad El Solh Street','H'),(21,'Islamic Hospital','06 444 725','Tripoli','Azmi Street','H'),(22,'Governmental Hospital of Tripoli','06 423 121','Tripoli','Qobbeh, Tripoli','H'),(23,'Hammoud Hospital University Medical Center','07 720 000','Saida','Riad El Solh Street','H'),(24,'Najjar Hospital','07 722 999','Saida','El Hout Street','H'),(25,'Jabal Amel Hospital','07 350 300','Tyre','Jal Al Bahr Street','H'),(26,'Nabatieh Governmental Hospital','07 760 800','Nabatieh','Nabatieh Main Road','H'),(27,'Rafik Hariri University Hospital','01 830 000','Beirut','Jnah, Beirut','H'),(28,'Mount Lebanon Hospital','01 372 888','Hazmieh','Hazmieh Main Road','H'),(29,'Bahman Hospital','01 555 555','Haret Hreik','Haret Hreik Main Street','H'),(30,'Dar Al Amal University Hospital','08 930 000','Baalbek','Ras El Ain Street','H');
/*!40000 ALTER TABLE `branch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `donor`
--

DROP TABLE IF EXISTS `donor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `donor` (
  `donor_ID` int NOT NULL,
  `blood_type` enum('A','B','AB','O') DEFAULT NULL,
  `rhesus` enum('+','-') DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `blood_id` int DEFAULT NULL,
  PRIMARY KEY (`donor_ID`),
  KEY `fkblood` (`blood_id`),
  CONSTRAINT `donor_ibfk_1` FOREIGN KEY (`donor_ID`) REFERENCES `individual` (`individual_ID`),
  CONSTRAINT `fkblood` FOREIGN KEY (`blood_id`) REFERENCES `blood_unit_tobedonated` (`blood_ID`),
  CONSTRAINT `chkbloodtype` CHECK ((`blood_type` in (_utf8mb4'A',_utf8mb4'B',_utf8mb4'AB',_utf8mb4'O'))),
  CONSTRAINT `chkrhesus` CHECK ((`rhesus` in (_utf8mb4'positive',_utf8mb4'negative')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `donor`
--

LOCK TABLES `donor` WRITE;
/*!40000 ALTER TABLE `donor` DISABLE KEYS */;
/*!40000 ALTER TABLE `donor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `health_care_professional`
--

DROP TABLE IF EXISTS `health_care_professional`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `health_care_professional` (
  `hc_professional_ID` int NOT NULL AUTO_INCREMENT,
  `firstName` varchar(50) DEFAULT NULL,
  `lastName` varchar(50) DEFAULT NULL,
  `phoneNumber` varchar(20) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `branch_id` int DEFAULT NULL,
  PRIMARY KEY (`hc_professional_ID`),
  KEY `fkb_ranch` (`branch_id`),
  CONSTRAINT `fkb_ranch` FOREIGN KEY (`branch_id`) REFERENCES `branch` (`branch_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `health_care_professional`
--

LOCK TABLES `health_care_professional` WRITE;
/*!40000 ALTER TABLE `health_care_professional` DISABLE KEYS */;
INSERT INTO `health_care_professional` VALUES (1,'Hassan','El Hage','01 234 567','Beirut',14),(2,'Maya','Karam','01 456 789','Beirut',3),(3,'Rami','Abou Khalil','09 876 543','Jounieh',18),(4,'Sarah','Nasr','07 123 456','Saida',12),(5,'Tarek','Haddad','08 765 432','Zahle',26),(6,'Lina','Aoun','06 234 567','Tripoli',7),(7,'Karim','Shoueiry','04 543 210','Antelias',9),(8,'Rania','Fakhry','01 678 901','Beirut',14),(9,'Nour','Daou','06 890 123','Halba',19),(10,'Ali','Merhi','07 456 789','Nabatieh',22),(11,'Fadi','Ghosn','01 345 678','Hazmieh',5),(12,'Hala','Sleiman','09 567 890','Jbeil',21),(13,'Ahmad','Kassem','07 890 123','Tyre',8),(14,'Jad','Bou Saab','01 678 234','Achrafieh',30),(15,'Reem','Salameh','01 987 654','Beirut',14),(16,'Yara','Itani','08 321 456','Beit Eddine',27),(17,'Marwan','Fayyad','06 765 432','Tripoli',7),(18,'Elie','Chahine','09 123 456','Jounieh',18),(19,'Joelle','Abou Nader','07 234 567','Saida',12),(20,'Bassam','Rahme','08 876 543','Zahle',26);
/*!40000 ALTER TABLE `health_care_professional` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `individual`
--

DROP TABLE IF EXISTS `individual`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `individual` (
  `individual_ID` int NOT NULL AUTO_INCREMENT,
  `firstName` varchar(50) DEFAULT NULL,
  `lastName` varchar(50) DEFAULT NULL,
  `gender` enum('Male','Female','Other') DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `phoneNumber` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`individual_ID`),
  UNIQUE KEY `email` (`email`),
  CONSTRAINT `chk_gender` CHECK ((`gender` in (_utf8mb4'M',_utf8mb4'F')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `individual`
--

LOCK TABLES `individual` WRITE;
/*!40000 ALTER TABLE `individual` DISABLE KEYS */;
/*!40000 ALTER TABLE `individual` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recipient`
--

DROP TABLE IF EXISTS `recipient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recipient` (
  `recipient_ID` int NOT NULL AUTO_INCREMENT,
  `email` varchar(100) DEFAULT NULL,
  `firstName` varchar(50) DEFAULT NULL,
  `lastName` varchar(50) DEFAULT NULL,
  `blood_type` varchar(3) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `phoneNumber` varchar(20) DEFAULT NULL,
  `blood_id` int DEFAULT NULL,
  PRIMARY KEY (`recipient_ID`),
  KEY `fk_blood` (`blood_id`),
  CONSTRAINT `fk_blood` FOREIGN KEY (`blood_id`) REFERENCES `blood_unit_tobedonated` (`blood_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recipient`
--

LOCK TABLES `recipient` WRITE;
/*!40000 ALTER TABLE `recipient` DISABLE KEYS */;
/*!40000 ALTER TABLE `recipient` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-12-11  0:45:18
