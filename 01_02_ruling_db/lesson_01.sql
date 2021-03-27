# 1) Установите СУБД MySQL. Создайте в домашней директории файл .my.cnf, задав в нем логин и пароль, который указывался
# при установке.


# prape@DESKTOP-F2U5O7B MINGW64 /c/Windows
# $ cat my.cnf
# [client]
# user=root
# password=4189
#
# prape@DESKTOP-F2U5O7B MINGW64 /c/Windows
# $ mysql
# Welcome to the MySQL monitor.  Commands end with ; or \g.
# Your MySQL connection id is 242
# Server version: 8.0.23 MySQL Community Server - GPL
#
# Copyright (c) 2000, 2021, Oracle and/or its affiliates.
#
# Oracle is a registered trademark of Oracle Corporation and/or its
# affiliates. Other names may be trademarks of their respective
# owners.
#
# Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.


# 2) Создайте базу данных example, разместите в ней таблицу users, состоящую из двух столбцов, числового id и
# строкового name.


CREATE DATABASE IF NOT EXISTS example;
DROP TABLE IF EXISTS users;
CREATE TABLE IF NOT EXISTS users
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    UNIQUE unique_name (name(10))
);
DESCRIBE users;

# 3) Создайте дамп базы данных example из предыдущего задания, разверните содержимое дампа в новую базу данных sample.


# prape@DESKTOP-F2U5O7B MINGW64 ~
# $ mysqldump example > example.sql
#
# prape@DESKTOP-F2U5O7B MINGW64 ~
# $ ll | grep example.sql
# -rw-r--r-- 1 prape 197609     1980 Mar  8 20:14 example.sql
#
# prape@DESKTOP-F2U5O7B MINGW64 ~
# $ echo 'create database sample' | mysql
#
# prape@DESKTOP-F2U5O7B MINGW64 ~
# $ mysql sample < example.sql
#
# prape@DESKTOP-F2U5O7B MINGW64 ~
# $ echo 'use sample; show tables' | mysql
# Tables_in_sample
# users


# 4) (по желанию) Ознакомьтесь более подробно с документацией утилиты mysqldump. Создайте дамп единственной таблицы
#   help_keyword базы данных mysql. Причем добейтесь того, чтобы дамп содержал только первые 100 строк таблицы.


# prape@DESKTOP-F2U5O7B MINGW64 ~
# $ mysqldump mysql help_keyword --where="help_keyword_id<101" > help_kw_table_100_rows.sql
#
# prape@DESKTOP-F2U5O7B MINGW64 ~
# $ cat help_kw_table_100_rows.sql
# -- MySQL dump 10.13  Distrib 8.0.23, for Win64 (x86_64)
# --
# -- Host: localhost    Database: mysql
# -- ------------------------------------------------------
# -- Server version       8.0.23
#
# /*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
# /*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
# /*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
# /*!50503 SET NAMES utf8mb4 */;
# /*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
# /*!40103 SET TIME_ZONE='+00:00' */;
# /*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
# /*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
# /*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
# /*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
#
# --
# -- Table structure for table `help_keyword`
# --
#
# DROP TABLE IF EXISTS `help_keyword`;
# /*!40101 SET @saved_cs_client     = @@character_set_client */;
# /*!50503 SET character_set_client = utf8mb4 */;
# CREATE TABLE `help_keyword` (
#   `help_keyword_id` int unsigned NOT NULL,
#   `name` char(64) NOT NULL,
#   PRIMARY KEY (`help_keyword_id`),
#   UNIQUE KEY `name` (`name`)
# ) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=utf8 STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC COMMENT='help keywords';
# /*!40101 SET character_set_client = @saved_cs_client */;
#
# --
# -- Dumping data for table `help_keyword`
# --
# -- WHERE:  help_keyword_id<101
#
# LOCK TABLES `help_keyword` WRITE;
# /*!40000 ALTER TABLE `help_keyword` DISABLE KEYS */;
# INSERT INTO `help_keyword` VALUES (0,'HELP_DATE'),(1,'HELP_VERSION'),(2,'DEFAULT'),(3,'SERIAL'),(4,'VALUE'),(5,'HELP'),(6,'ASYMMETRIC_DECRYPT'),(7,'ASYMMETRIC_DERIVE'),(8,'ASYMMETRIC_ENCRYPT'),(9,'ASYMMETRIC_SIGN'),(10,'ASYMMETRIC_VERIFY'),(11,'CREATE_ASYMMETRIC_PRIV_KEY'),(12,'CREATE_ASYMMETRIC_PUB_KEY'),(13,'CREATE_DH_PARAMETERS'),(14,'CREATE_DIGEST'),(15,'FALSE'),(16,'TRUE'),(17,'BOOL'),(18,'BOOLEAN'),(19,'INT1'),(20,'UNSIGNED'),(21,'ZEROFILL'),(22,'INT2'),(23,'INT3'),(24,'MIDDLEINT'),(25,'INT4'),(26,'INTEGER'),(27,'INT8'),(28,'DEC'),(29,'FIXED'),(30,'NUMERIC'),(31,'DECIMAL'),(32,'FLOAT4'),(33,'FLOAT8'),(34,'PRECISION'),(35,'REAL'),(36,'DATE'),(37,'TIMESTAMP'),(38,'TIME'),(39,'CHARACTER'),(40,'NATIONAL'),(41,'NCHAR'),(42,'BYTE'),(43,'CHAR'),(44,'NVARCHAR'),(45,'VARCHARACTER'),(46,'VARYING'),(47,'LONG'),(48,'LONGBINARY'),(49,'ADD'),(50,'ALTER'),(51,'CREATE'),(52,'INDEX'),(53,'KEY'),(54,'TABLE'),(55,'='),(56,'<=>'),(57,'<>'),(58,'<='),(59,'<'),(60,'>='),(61,'>'),(62,'AND'),(63,'BETWEEN'),(64,'NOT'),(65,'COALESCE'),(66,'GREATEST'),(67,'IN'),(68,'INTERVAL'),(69,'IS'),(70,'NULL'),(71,'ISNULL'),(72,'LEAST'),(73,'OR'),(74,'XOR'),(75,':='),(76,'CASE'),(77,'ELSE'),(78,'END'),(79,'THEN'),(80,'WHEN'),(81,'IF'),(82,'IFNULL'),(83,'NULLIF'),(84,'+'),(85,'-'),(86,'*'),(87,'/'),(88,'DIV'),(89,'MOD'),(90,'ABS'),(91,'ACOS'),(92,'ASIN'),(93,'ATAN'),(94,'ATAN2'),(95,'CEIL'),(96,'CEILING'),(97,'CONV'),(98,'COS'),(99,'COT'),(100,'CRC32');
# /*!40000 ALTER TABLE `help_keyword` ENABLE KEYS */;
# UNLOCK TABLES;
# /*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
#
# /*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
# /*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
# /*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
# /*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
# /*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
# /*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
# /*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
#
# -- Dump completed on 2021-03-08 20:38:02

# prape@DESKTOP-F2U5O7B MINGW64 ~
# $ vim help_kw_table_100_rows.sql

# тут закомментил зарезервированное TABLESPACE 'mysql', иначе не хотела записывать
#
# prape@DESKTOP-F2U5O7B MINGW64 ~
# $ mysql sample < help_kw_table_100_rows.sql

# prape@DESKTOP-F2U5O7B MINGW64 ~
# $ echo 'USE sample; SELECT * FROM help_keyword' | mysql
# help_keyword_id name
# 86      *
# 84      +
# 85      -
# 87      /
# 75      :=
# 59      <
# 58      <=
# 56      <=>
# 57      <>
# 55      =
# 61      >
# 60      >=
# 90      ABS
# 91      ACOS
# 49      ADD
# 50      ALTER
# 62      AND
# 92      ASIN
# 6       ASYMMETRIC_DECRYPT
# 7       ASYMMETRIC_DERIVE
# 8       ASYMMETRIC_ENCRYPT
# 9       ASYMMETRIC_SIGN
# 10      ASYMMETRIC_VERIFY
# 93      ATAN
# 94      ATAN2
# 63      BETWEEN
# 17      BOOL
# 18      BOOLEAN
# 42      BYTE
# 76      CASE
# 95      CEIL
# 96      CEILING
# 43      CHAR
# 39      CHARACTER
# 65      COALESCE
# 97      CONV
# 98      COS
# 99      COT
# 100     CRC32
# 51      CREATE
# 11      CREATE_ASYMMETRIC_PRIV_KEY
# 12      CREATE_ASYMMETRIC_PUB_KEY
# 13      CREATE_DH_PARAMETERS
# 14      CREATE_DIGEST
# 36      DATE
# 28      DEC
# 31      DECIMAL
# 2       DEFAULT
# 88      DIV
# 77      ELSE
# 78      END
# 15      FALSE
# 29      FIXED
# 32      FLOAT4
# 33      FLOAT8
# 66      GREATEST
# 5       HELP
# 0       HELP_DATE
# 1       HELP_VERSION
# 81      IF
# 82      IFNULL
# 67      IN
# 52      INDEX
# 19      INT1
# 22      INT2
# 23      INT3
# 25      INT4
# 27      INT8
# 26      INTEGER
# 68      INTERVAL
# 69      IS
# 71      ISNULL
# 53      KEY
# 72      LEAST
# 47      LONG
# 48      LONGBINARY
# 24      MIDDLEINT
# 89      MOD
# 40      NATIONAL
# 41      NCHAR
# 64      NOT
# 70      NULL
# 83      NULLIF
# 30      NUMERIC
# 44      NVARCHAR
# 73      OR
# 34      PRECISION
# 35      REAL
# 3       SERIAL
# 54      TABLE
# 79      THEN
# 38      TIME
# 37      TIMESTAMP
# 16      TRUE
# 20      UNSIGNED
# 4       VALUE
# 45      VARCHARACTER
# 46      VARYING
# 80      WHEN
# 74      XOR
# 21      ZEROFILL

