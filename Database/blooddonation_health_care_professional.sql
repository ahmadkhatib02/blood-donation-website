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
-- Table structure for table `health_care_professional`
--

DROP TABLE IF EXISTS `health_care_professional`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `health_care_professional` (
  `hc_professional_ID` int NOT NULL AUTO_INCREMENT,
  `firstName` varchar(50) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phoneNumber` varchar(20) NOT NULL,
  `branch_ID` int NOT NULL,
  PRIMARY KEY (`hc_professional_ID`),
  KEY `branch_ID` (`branch_ID`),
  CONSTRAINT `health_care_professional_ibfk_1` FOREIGN KEY (`branch_ID`) REFERENCES `branch` (`branch_ID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `health_care_professional`
--

LOCK TABLES `health_care_professional` WRITE;
/*!40000 ALTER TABLE `health_care_professional` DISABLE KEYS */;
INSERT INTO `health_care_professional` VALUES (1,'Hassan','El Hage','hassan.elhage@example.com','H@ssan2024!','01 234 567',1),(2,'Maya','Karam','maya.karam@example.com','Maya!2024Karam','01 456 789',1),(3,'Rami','Abou Khalil','rami.aboukhalil@example.com','R@mi2024Aboukhalil','09 876 543',4),(4,'Sarah','Nasr','sarah.nasr@example.com','S@rah123!Nasr','07 123 456',10),(5,'Tarek','Haddad','tarek.haddad@example.com','T@rek#2024Haddad','08 765 432',8),(6,'Lina','Aoun','lina.aoun@example.com','L!naAoun2024$','06 234 567',6),(7,'Karim','Shoueiry','karim.shoueiry@example.com','K@rim2024Shoueiry','04 543 210',3),(8,'Rania','Fakhry','rania.fakhry@example.com','R@nia2024Fakhry!','01 678 901',1),(9,'Nour','Daou','nour.daou@example.com','N0urD@ou2024','06 890 123',7),(10,'Ali','Merhi','ali.merhi@example.com','A!Merhi2024$','07 456 789',11),(11,'Fadi','Ghosn','fadi.ghosn@example.com','F@diGhosn#2024','01 345 678',28),(12,'Hala','Sleiman','hala.sleiman@example.com','H@laSleiman2024','09 567 890',5),(13,'Ahmad','Kassem','ahmad.kassem@example.com','Ahm@dKassem2024!','07 890 123',25),(14,'Jad','Bou Saab','jad.bousaab@example.com','J@d2024Bousaab','01 678 234',16),(15,'Reem','Salameh','reem.salameh@example.com','R33mS@l@meh2024','01 987 654',1),(16,'Yara','Itani','yara.itani@example.com','Y@r@Itani2024!','08 321 456',9),(17,'Marwan','Fayyad','marwan.fayyad@example.com','M@rwanFayyad2024','06 765 432',6),(18,'Elie','Chahine','elie.chahine@example.com','El!eChahine2024$','09 123 456',4),(19,'Joelle','Abou Nader','joelle.abounader@example.com','J0elle#2024AbouNader','07 234 567',10),(20,'Bassam','Rahme','bassam.rahme@example.com','B@ssamRahme2024!','08 876 543',8);
/*!40000 ALTER TABLE `health_care_professional` ENABLE KEYS */;
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
