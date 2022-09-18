-- MySQL dump 10.13  Distrib 8.0.30, for Linux (x86_64)
--
-- Host: localhost    Database: error-tracking
-- ------------------------------------------------------
-- Server version	8.0.30

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `defect_history`
--

DROP TABLE IF EXISTS `defect_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `defect_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `action_id` int NOT NULL,
  `comment` text NOT NULL,
  `defect_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `defect_history_id_uindex` (`id`),
  KEY `defect_history_defects_id_fk` (`defect_id`),
  KEY `defect_history_dict_history_action_id_fk` (`action_id`),
  KEY `defect_history_users_id_fk` (`user_id`),
  CONSTRAINT `defect_history_defects_id_fk` FOREIGN KEY (`defect_id`) REFERENCES `defects` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `defect_history_dict_history_action_id_fk` FOREIGN KEY (`action_id`) REFERENCES `dict_history_action` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `defect_history_users_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `defect_history`
--

LOCK TABLES `defect_history` WRITE;
/*!40000 ALTER TABLE `defect_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `defect_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `defects`
--

DROP TABLE IF EXISTS `defects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `defects` (
  `id` int NOT NULL AUTO_INCREMENT,
  `short_description` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `created_by` int NOT NULL,
  `state_id` int NOT NULL,
  `level_id` int NOT NULL,
  `urgency_id` int NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `defects_id_uindex` (`id`),
  KEY `defects_users_id_fk` (`created_by`),
  KEY `defects_dict_defect_level_id_fk` (`level_id`),
  KEY `defects_dict_defect_state_id_fk` (`state_id`),
  KEY `defects_dict_defect_urgency_id_fk` (`urgency_id`),
  CONSTRAINT `defects_dict_defect_level_id_fk` FOREIGN KEY (`level_id`) REFERENCES `dict_defect_level` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `defects_dict_defect_state_id_fk` FOREIGN KEY (`state_id`) REFERENCES `dict_defect_state` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `defects_dict_defect_urgency_id_fk` FOREIGN KEY (`urgency_id`) REFERENCES `dict_defect_urgency` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `defects_users_id_fk` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `defects`
--

LOCK TABLES `defects` WRITE;
/*!40000 ALTER TABLE `defects` DISABLE KEYS */;
/*!40000 ALTER TABLE `defects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dict_defect_level`
--

DROP TABLE IF EXISTS `dict_defect_level`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dict_defect_level` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dict_defect_level_id_uindex` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dict_defect_level`
--

LOCK TABLES `dict_defect_level` WRITE;
/*!40000 ALTER TABLE `dict_defect_level` DISABLE KEYS */;
INSERT INTO `dict_defect_level` VALUES (1,'Авария'),(2,'Критичная ошибка'),(3,'Некритичная ошибка'),(4,'Запрос изменения');
/*!40000 ALTER TABLE `dict_defect_level` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dict_defect_state`
--

DROP TABLE IF EXISTS `dict_defect_state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dict_defect_state` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dict_defect_state_id_uindex` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dict_defect_state`
--

LOCK TABLES `dict_defect_state` WRITE;
/*!40000 ALTER TABLE `dict_defect_state` DISABLE KEYS */;
INSERT INTO `dict_defect_state` VALUES (1,'Новая'),(2,'Открытая'),(3,'Решённая'),(4,'Закрытая');
/*!40000 ALTER TABLE `dict_defect_state` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dict_defect_urgency`
--

DROP TABLE IF EXISTS `dict_defect_urgency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dict_defect_urgency` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dict_defect_urgency_id_uindex` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dict_defect_urgency`
--

LOCK TABLES `dict_defect_urgency` WRITE;
/*!40000 ALTER TABLE `dict_defect_urgency` DISABLE KEYS */;
INSERT INTO `dict_defect_urgency` VALUES (1,'Очень срочно'),(2,'Срочно'),(3,'Не срочно'),(4,'Совсем не срочно');
/*!40000 ALTER TABLE `dict_defect_urgency` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dict_history_action`
--

DROP TABLE IF EXISTS `dict_history_action`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dict_history_action` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dict_history_action_id_uindex` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dict_history_action`
--

LOCK TABLES `dict_history_action` WRITE;
/*!40000 ALTER TABLE `dict_history_action` DISABLE KEYS */;
INSERT INTO `dict_history_action` VALUES (1,'Ввод'),(2,'Открытие'),(3,'Решение'),(4,'Закрытие');
/*!40000 ALTER TABLE `dict_history_action` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `surname` varchar(100) NOT NULL,
  `login` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_id_uindex` (`id`),
  UNIQUE KEY `users_login_uindex` (`login`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-09-18 14:11:51
