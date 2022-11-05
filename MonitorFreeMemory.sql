CREATE DATABASE IF NOT EXISTS ritmania;
USE ritmania;
CREATE TABLE `memoryusage` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `hostname` varchar(100) DEFAULT NULL,
  `freememory` int DEFAULT NULL,
  `date` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`ID`)
);