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
  `appointment_id` int NOT NULL AUTO_INCREMENT,
  `appointment_date` date NOT NULL,
  `donor_id` int NOT NULL,
  `branch_id` int NOT NULL,
  `hc_professional_id` int DEFAULT NULL,
  PRIMARY KEY (`appointment_id`),
  KEY `donor_id` (`donor_id`),
  KEY `branch_id` (`branch_id`),
  KEY `hc_professional_id` (`hc_professional_id`),
  CONSTRAINT `appointment_ibfk_1` FOREIGN KEY (`donor_id`) REFERENCES `donor` (`donor_id`),
  CONSTRAINT `appointment_ibfk_2` FOREIGN KEY (`branch_id`) REFERENCES `branch` (`branch_id`),
  CONSTRAINT `appointment_ibfk_3` FOREIGN KEY (`hc_professional_id`) REFERENCES `hc_professional` (`hc_professional_id`)
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
  `blood_id` int NOT NULL AUTO_INCREMENT,
  `blood_type` varchar(2) NOT NULL,
  `rhesus` char(1) DEFAULT NULL,
  `donor_id` int NOT NULL,
  `recipient_id` int DEFAULT NULL,
  `branch_id` int NOT NULL,
  PRIMARY KEY (`blood_id`),
  KEY `donor_id` (`donor_id`),
  KEY `recipient_id` (`recipient_id`),
  KEY `branch_id` (`branch_id`),
  CONSTRAINT `blood_unit_tobedonated_ibfk_1` FOREIGN KEY (`donor_id`) REFERENCES `donor` (`donor_id`),
  CONSTRAINT `blood_unit_tobedonated_ibfk_2` FOREIGN KEY (`recipient_id`) REFERENCES `recipient` (`recipient_id`),
  CONSTRAINT `blood_unit_tobedonated_ibfk_3` FOREIGN KEY (`branch_id`) REFERENCES `branch` (`branch_id`),
  CONSTRAINT `blood_unit_tobedonated_chk_1` CHECK ((`blood_type` in (_utf8mb4'A',_utf8mb4'B',_utf8mb4'O',_utf8mb4'AB'))),
  CONSTRAINT `blood_unit_tobedonated_chk_2` CHECK ((`rhesus` in (_utf8mb4'positive',_utf8mb4'negative')))
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
  `branch_id` int NOT NULL AUTO_INCREMENT,
  `branch_name` varchar(200) NOT NULL,
  `city` varchar(100) DEFAULT NULL,
  `street` varchar(100) DEFAULT NULL,
  `phoneNumber` varchar(15) DEFAULT NULL,
  `type` char(1) DEFAULT NULL,
  PRIMARY KEY (`branch_id`),
  CONSTRAINT `branch_chk_1` CHECK ((`type` in (_utf8mb4'H',_utf8mb4'R')))
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `branch`
--

LOCK TABLES `branch` WRITE;
/*!40000 ALTER TABLE `branch` DISABLE KEYS */;
INSERT INTO `branch` VALUES (1,'Lebanese Red Cross Blood Donation Center - Spears','Beirut','Spears Street, Kantari','01 368 681','R'),(2,'Lebanese Red Cross Blood Donation Center - Gemmayze','Beirut','Gouraud Street, Gemmayze','01 444 102','R'),(3,'Lebanese Red Cross Blood Donation Center - Antelias','Antelias','Main Street, Antelias','04 524 164','R'),(4,'Lebanese Red Cross Blood Donation Center - Jounieh','Jounieh','Near Fouad Chehab Stadium','09 930 488','R'),(5,'Lebanese Red Cross Blood Donation Center - Jbeil','Jbeil','Facing the Municipality','09 945 220','R'),(6,'Lebanese Red Cross Blood Donation Center - Tripoli','Tripoli','Dam w Farez Street','06 601 429','R'),(7,'Lebanese Red Cross Blood Donation Center - Halba','Halba','Main Road, Halba','06 695 370','R'),(8,'Lebanese Red Cross Blood Donation Center - Zahle','Zahle','Brazil Street','08 804 930','R'),(9,'Lebanese Red Cross Blood Donation Center - Beit Eddine','Beit Eddine','Main Road, Beit Eddine','03 468 728','R'),(10,'Lebanese Red Cross Blood Donation Center - Saida','Saida','Riad El Solh Street','07 752 141','R'),(11,'Lebanese Red Cross Blood Donation Center - Nabatieh','Nabatieh','Nabatieh Main Road','07 768 687','R'),(12,'Lebanese Red Cross Blood Donation Center - Tyre','Tyre','Jall Al Bahr Street','07 351 370','R'),(13,'Lebanese Red Cross Blood Donation Center - Rachaya','Rachaya','Main Road, Rachaya','08 595 789','R'),(14,'American University of Beirut Medical Center (AUBMC)','Beirut','Cairo Street, Hamra','01 350 000','H'),(15,'Al Zahraa Hospital University Medical Center','Beirut','Airport Road, Bir Hassan','01 822 610','H'),(16,'Saint George Hospital University Medical Center','Beirut','Ashrafieh, Beirut','01 441 000','H'),(17,'Hôtel-Dieu de France','Beirut','Alfred Naccache Street, Achrafieh','01 615 300','H'),(18,'Makassed General Hospital','Beirut','Tarik El Jdideh','01 370 555','H'),(19,'Lebanese Hospital Geitaoui','Beirut','Achrafieh, Beirut','01 590 000','H'),(20,'Nini Hospital','Tripoli','Riad El Solh Street','06 430 430','H'),(21,'Islamic Hospital','Tripoli','Azmi Street','06 444 725','H'),(22,'Governmental Hospital of Tripoli','Tripoli','Qobbeh, Tripoli','06 423 121','H'),(23,'Hammoud Hospital University Medical Center','Saida','Riad El Solh Street','07 720 000','H'),(24,'Najjar Hospital','Saida','El Hout Street','07 722 999','H'),(25,'Jabal Amel Hospital','Tyre','Jal Al Bahr Street','07 350 300','H'),(26,'Nabatieh Governmental Hospital','Nabatieh','Nabatieh Main Road','07 760 800','H'),(27,'Rafik Hariri University Hospital','Beirut','Jnah, Beirut','01 830 000','H'),(28,'Mount Lebanon Hospital','Hazmieh','Hazmieh Main Road','01 372 888','H'),(29,'Bahman Hospital','Haret Hreik','Haret Hreik Main Street','01 555 555','H'),(30,'Dar Al Amal University Hospital','Baalbek','Ras El Ain Street','08 930 000','H');
/*!40000 ALTER TABLE `branch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `donor`
--

DROP TABLE IF EXISTS `donor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `donor` (
  `donor_id` int NOT NULL AUTO_INCREMENT,
  `individual_id` int NOT NULL,
  `blood_type` varchar(2) NOT NULL,
  `rhesus` char(1) DEFAULT NULL,
  `isQualified` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`donor_id`),
  KEY `individual_id` (`individual_id`),
  CONSTRAINT `donor_ibfk_1` FOREIGN KEY (`individual_id`) REFERENCES `individual` (`individual_id`),
  CONSTRAINT `donor_chk_1` CHECK ((`blood_type` in (_utf8mb4'A',_utf8mb4'B',_utf8mb4'O',_utf8mb4'AB'))),
  CONSTRAINT `donor_chk_2` CHECK ((`rhesus` in (_utf8mb4'positive',_utf8mb4'negative')))
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
-- Table structure for table `hc_professional`
--

DROP TABLE IF EXISTS `hc_professional`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hc_professional` (
  `hc_professional_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `password` varchar(60) NOT NULL,
  `phoneNumber` varchar(15) DEFAULT NULL,
  `branch_id` int NOT NULL,
  PRIMARY KEY (`hc_professional_id`),
  UNIQUE KEY `email` (`email`),
  KEY `branch_id` (`branch_id`),
  CONSTRAINT `hc_professional_ibfk_1` FOREIGN KEY (`branch_id`) REFERENCES `branch` (`branch_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hc_professional`
--

LOCK TABLES `hc_professional` WRITE;
/*!40000 ALTER TABLE `hc_professional` DISABLE KEYS */;
INSERT INTO `hc_professional` VALUES (1,'Hassan','El Hage','hassan.elhage@example.com','H@ssan2024!','01 234 567',1),(2,'Maya','Karam','maya.karam@example.com','Maya!2024Karam','01 456 789',1),(3,'Rami','Abou Khalil','rami.aboukhalil@example.com','R@mi2024Aboukhalil','09 876 543',4),(4,'Sarah','Nasr','sarah.nasr@example.com','S@rah123!Nasr','07 123 456',10),(5,'Tarek','Haddad','tarek.haddad@example.com','T@rek#2024Haddad','08 765 432',8),(6,'Lina','Aoun','lina.aoun@example.com','L!naAoun2024$','06 234 567',6),(7,'Karim','Shoueiry','karim.shoueiry@example.com','K@rim2024Shoueiry','04 543 210',3),(8,'Rania','Fakhry','rania.fakhry@example.com','R@nia2024Fakhry!','01 678 901',1),(9,'Nour','Daou','nour.daou@example.com','N0urD@ou2024','06 890 123',7),(10,'Ali','Merhi','ali.merhi@example.com','A!Merhi2024$','07 456 789',11),(11,'Fadi','Ghosn','fadi.ghosn@example.com','F@diGhosn#2024','01 345 678',28),(12,'Hala','Sleiman','hala.sleiman@example.com','H@laSleiman2024','09 567 890',5),(13,'Ahmad','Kassem','ahmad.kassem@example.com','Ahm@dKassem2024!','07 890 123',25),(14,'Jad','Bou Saab','jad.bousaab@example.com','J@d2024Bousaab','01 678 234',16),(15,'Reem','Salameh','reem.salameh@example.com','R33mS@l@meh2024','01 987 654',1),(16,'Yara','Itani','yara.itani@example.com','Y@r@Itani2024!','08 321 456',9),(17,'Marwan','Fayyad','marwan.fayyad@example.com','M@rwanFayyad2024','06 765 432',6),(18,'Elie','Chahine','elie.chahine@example.com','El!eChahine2024$','09 123 456',4),(19,'Joelle','Abou Nader','joelle.abounader@example.com','J0elle#2024AbouNader','07 234 567',10),(20,'Bassam','Rahme','bassam.rahme@example.com','B@ssamRahme2024!','08 876 543',8);
/*!40000 ALTER TABLE `hc_professional` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `individual`
--

DROP TABLE IF EXISTS `individual`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `individual` (
  `individual_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `gender` char(1) NOT NULL,
  `phoneNumber` varchar(15) NOT NULL,
  `email` varchar(60) NOT NULL,
  `password` varchar(200) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`individual_id`),
  UNIQUE KEY `email` (`email`),
  CONSTRAINT `individual_chk_1` CHECK ((`gender` in (_utf8mb4'M',_utf8mb4'F')))
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
  `recipient_id` int NOT NULL AUTO_INCREMENT,
  `blood_type` enum('A+','A-','B+','B-','AB+','AB-','O+','O-') NOT NULL,
  `email` varchar(100) NOT NULL,
  PRIMARY KEY (`recipient_id`)
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

-- Dump completed on 2024-12-12 12:12:30
