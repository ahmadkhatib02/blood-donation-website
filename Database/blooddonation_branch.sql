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
-- Table structure for table `branch`
--

DROP TABLE IF EXISTS `branch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `branch` (
  `branch_ID` int NOT NULL AUTO_INCREMENT,
  `branch_Name` varchar(100) NOT NULL,
  `city` varchar(100) NOT NULL,
  `street` varchar(100) NOT NULL,
  `phoneNumber` varchar(20) NOT NULL,
  `type` varchar(50) NOT NULL,
  PRIMARY KEY (`branch_ID`)
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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-12-20 12:37:02
