-- MySQL dump 10.13  Distrib 8.4.13, for macos15.8 (arm64)
--
-- Host: 127.0.0.1    Database: trajeloc
-- ------------------------------------------------------
-- Server version	8.4.13

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
-- Current Database: `trajeloc`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `trajeloc` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `trajeloc`;

--
-- Table structure for table `ajuste`
--

DROP TABLE IF EXISTS `ajuste`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ajuste` (
  `id_ajuste` int NOT NULL AUTO_INCREMENT,
  `id_item` int NOT NULL,
  `descricao` text NOT NULL,
  PRIMARY KEY (`id_ajuste`),
  KEY `idx_ajuste_id_item` (`id_item`),
  CONSTRAINT `ajuste_ibfk_1` FOREIGN KEY (`id_item`) REFERENCES `item_locacao` (`id_item`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ajuste`
--

LOCK TABLES `ajuste` WRITE;
/*!40000 ALTER TABLE `ajuste` DISABLE KEYS */;
INSERT INTO `ajuste` VALUES (1,1,'Ajustar barra da calça em 2 cm'),(2,2,'Apertar a cintura do vestido em 1 cm'),(3,3,'Ajustar comprimento da manga do paletó'),(4,4,'Reduzir o busto em 1,5 cm e subir a alça'),(5,7,'Fazer bainha para salto de 10 cm'),(6,8,'Encurtar as alças em 2 cm');
/*!40000 ALTER TABLE `ajuste` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cliente`
--

DROP TABLE IF EXISTS `cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cliente` (
  `id_cliente` int NOT NULL AUTO_INCREMENT,
  `id_usuario` int DEFAULT NULL,
  `nome` varchar(100) NOT NULL,
  `cpf` char(14) NOT NULL,
  `telefone` varchar(20) NOT NULL,
  `endereco` varchar(150) NOT NULL,
  `rg` varchar(20) DEFAULT NULL,
  `medidas` text,
  `data_nascimento` date DEFAULT NULL,
  PRIMARY KEY (`id_cliente`),
  UNIQUE KEY `cpf` (`cpf`),
  UNIQUE KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `cliente_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente`
--

LOCK TABLES `cliente` WRITE;
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
INSERT INTO `cliente` VALUES (1,5,'Roberto Alves','111.222.333-44','(19) 98765-4321','Rua das Flores, 123 - Indaiatuba','12.345.678-9','Tórax: 98, Cintura: 84, Calça: 42','1990-05-15'),(2,6,'Fernanda Costa','222.333.444-55','(19) 97654-3210','Av. Presidente Vargas, 456 - Indaiatuba','23.456.789-0','Busto: 85, Cintura: 70, Quadril: 95','1995-08-20'),(3,7,'Lucas Santos','333.444.555-66','(19) 96543-2109','Rua XV de Novembro, 789 - Campinas','34.567.890-1','Tórax: 102, Cintura: 88','1988-12-10'),(4,9,'Ana Beatriz Moura','444.111.222-33','(19) 99812-3344','Rua Pedro Gonçalves, 210 - Indaiatuba','45.123.456-7','Busto: 80, Cintura: 62, Quadril: 88','2011-02-14'),(5,10,'Rafael Teixeira','555.222.333-44','(19) 98123-7788','Av. Conceição, 1500 - Indaiatuba','56.234.567-8','Tórax: 108, Cintura: 96, Calça: 46','1983-09-03'),(6,NULL,'Camila Ferreira','666.333.444-55','(11) 97452-9090','Rua Sete de Setembro, 88 - Salto','67.345.678-9','Busto: 88, Cintura: 68, Quadril: 96','1999-06-27');
/*!40000 ALTER TABLE `cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `funcionario`
--

DROP TABLE IF EXISTS `funcionario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `funcionario` (
  `id_funcionario` int NOT NULL AUTO_INCREMENT,
  `id_usuario` int NOT NULL,
  `nome` varchar(100) NOT NULL,
  `cpf` char(14) NOT NULL,
  `rg` varchar(20) DEFAULT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `ctps` varchar(20) DEFAULT NULL,
  `dependente` int NOT NULL DEFAULT '0',
  `sexo` varchar(20) DEFAULT NULL,
  `salario` decimal(10,2) DEFAULT NULL,
  `data_nascimento` date DEFAULT NULL,
  `estado_civil` varchar(30) DEFAULT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_funcionario`),
  UNIQUE KEY `id_usuario` (`id_usuario`),
  UNIQUE KEY `cpf` (`cpf`),
  CONSTRAINT `funcionario_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `funcionario`
--

LOCK TABLES `funcionario` WRITE;
/*!40000 ALTER TABLE `funcionario` DISABLE KEYS */;
INSERT INTO `funcionario` VALUES (1,2,'Mariana Lima','444.555.666-77','45.678.901-2','(19) 95432-1098','1234567/0001',1,'Feminino',2800.00,'1992-03-25','Casada',1),(2,3,'Juliana Mendes','555.666.777-88','56.789.012-3','(19) 94321-0987','2345678/0001',0,'Feminino',2500.00,'1997-07-11','Solteira',1),(3,4,'Gerson Nogueira','666.777.888-99','67.890.123-4','(19) 93210-9876','3456789/0001',2,'Masculino',3100.00,'1985-01-30','Casado',1),(4,8,'Patrícia Rocha','777.888.999-00','78.901.234-5','(19) 92109-8765','4567890/0001',0,'Feminino',2400.00,'2001-10-18','Solteira',1),(5,1,'Carlos Andrade','888.999.000-11','89.012.345-6','(19) 99001-2233','5678901/0001',2,'Masculino',4500.00,'1982-11-05','Casado',1);
/*!40000 ALTER TABLE `funcionario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historico_peca`
--

DROP TABLE IF EXISTS `historico_peca`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historico_peca` (
  `id_historico` int NOT NULL AUTO_INCREMENT,
  `id_peca` int NOT NULL,
  `id_status` int NOT NULL,
  `data_inicio` datetime NOT NULL,
  `data_fim` datetime DEFAULT NULL,
  PRIMARY KEY (`id_historico`),
  KEY `idx_historico_peca_id_peca` (`id_peca`),
  KEY `idx_historico_peca_id_status` (`id_status`),
  CONSTRAINT `historico_peca_ibfk_1` FOREIGN KEY (`id_peca`) REFERENCES `peca_produto` (`id_peca`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `historico_peca_ibfk_2` FOREIGN KEY (`id_status`) REFERENCES `status_peca` (`id_status`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historico_peca`
--

LOCK TABLES `historico_peca` WRITE;
/*!40000 ALTER TABLE `historico_peca` DISABLE KEYS */;
INSERT INTO `historico_peca` VALUES (1,1,1,'2026-01-05 09:00:00',NULL),(2,2,2,'2026-09-28 10:00:00','2026-10-03 18:00:00'),(3,2,4,'2026-10-04 09:00:00','2026-10-06 17:00:00'),(4,3,5,'2026-08-20 09:00:00','2026-08-22 17:00:00'),(5,3,2,'2026-11-15 14:00:00',NULL),(6,6,3,'2026-11-18 10:00:00',NULL),(7,7,5,'2026-11-03 09:00:00','2026-11-04 16:00:00'),(8,4,1,'2026-11-07 09:00:00',NULL);
/*!40000 ALTER TABLE `historico_peca` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_locacao`
--

DROP TABLE IF EXISTS `item_locacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_locacao` (
  `id_item` int NOT NULL AUTO_INCREMENT,
  `id_locacao` int NOT NULL,
  `id_peca` int NOT NULL,
  `preco_aluguel` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id_item`),
  KEY `idx_item_locacao_id_locacao` (`id_locacao`),
  KEY `idx_item_locacao_id_peca` (`id_peca`),
  CONSTRAINT `item_locacao_ibfk_1` FOREIGN KEY (`id_locacao`) REFERENCES `locacao` (`id_locacao`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `item_locacao_ibfk_2` FOREIGN KEY (`id_peca`) REFERENCES `peca_produto` (`id_peca`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_locacao`
--

LOCK TABLES `item_locacao` WRITE;
/*!40000 ALTER TABLE `item_locacao` DISABLE KEYS */;
INSERT INTO `item_locacao` VALUES (1,1,1,250.00),(2,2,2,380.00),(3,3,3,300.00),(4,4,6,450.00),(5,5,5,280.00),(6,5,7,350.00),(7,6,4,420.00),(8,6,8,320.00),(9,7,2,380.00);
/*!40000 ALTER TABLE `item_locacao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `locacao`
--

DROP TABLE IF EXISTS `locacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `locacao` (
  `id_locacao` int NOT NULL AUTO_INCREMENT,
  `id_cliente` int NOT NULL,
  `id_usuario` int NOT NULL,
  `id_funcionario` int NOT NULL,
  `data_evento` date NOT NULL,
  `data_entrega` date DEFAULT NULL,
  `data_devolucao` date DEFAULT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'RESERVADA',
  `multa` decimal(10,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id_locacao`),
  KEY `idx_locacao_id_cliente` (`id_cliente`),
  KEY `idx_locacao_id_funcionario` (`id_funcionario`),
  KEY `idx_locacao_id_usuario` (`id_usuario`),
  KEY `idx_locacao_data_evento` (`data_evento`),
  CONSTRAINT `locacao_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `locacao_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `locacao_ibfk_3` FOREIGN KEY (`id_funcionario`) REFERENCES `funcionario` (`id_funcionario`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `locacao`
--

LOCK TABLES `locacao` WRITE;
/*!40000 ALTER TABLE `locacao` DISABLE KEYS */;
INSERT INTO `locacao` VALUES (1,1,2,1,'2026-11-10','2026-11-09','2026-11-12','CONCLUIDA',0.00),(2,2,2,1,'2026-10-01','2026-09-30','2026-10-03','CONCLUIDA',0.00),(3,3,3,2,'2026-12-05','2026-12-04',NULL,'RESERVADA',0.00),(4,4,3,2,'2026-12-12','2026-12-11','2026-12-14','RESERVADA',0.00),(5,5,4,3,'2026-11-28','2026-11-27','2026-11-30','RESERVADA',0.00),(6,2,2,1,'2026-12-19','2026-12-18','2026-12-21','RESERVADA',0.00),(7,6,8,4,'2026-10-17','2026-10-16','2026-10-19','CONCLUIDA',40.00);
/*!40000 ALTER TABLE `locacao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `manutencao`
--

DROP TABLE IF EXISTS `manutencao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manutencao` (
  `id_manutencao` int NOT NULL AUTO_INCREMENT,
  `id_peca` int NOT NULL,
  `descricao` text NOT NULL,
  `data_manutencao` date NOT NULL,
  PRIMARY KEY (`id_manutencao`),
  KEY `idx_manutencao_id_peca` (`id_peca`),
  CONSTRAINT `manutencao_ibfk_1` FOREIGN KEY (`id_peca`) REFERENCES `peca_produto` (`id_peca`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `manutencao`
--

LOCK TABLES `manutencao` WRITE;
/*!40000 ALTER TABLE `manutencao` DISABLE KEYS */;
INSERT INTO `manutencao` VALUES (1,1,'Lavagem a seco e passadoria','2026-10-05'),(2,2,'Troca do zíper invisível das costas','2026-09-15'),(3,3,'Remoção de mancha na lapela','2026-08-20'),(4,7,'Costura da lapela descosturada','2026-11-03'),(5,4,'Reposição de pedrarias do busto','2026-11-06');
/*!40000 ALTER TABLE `manutencao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pagamento`
--

DROP TABLE IF EXISTS `pagamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pagamento` (
  `id_pagamento` int NOT NULL AUTO_INCREMENT,
  `id_locacao` int NOT NULL,
  `valor` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id_pagamento`),
  KEY `idx_pagamento_id_locacao` (`id_locacao`),
  CONSTRAINT `pagamento_ibfk_1` FOREIGN KEY (`id_locacao`) REFERENCES `locacao` (`id_locacao`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pagamento`
--

LOCK TABLES `pagamento` WRITE;
/*!40000 ALTER TABLE `pagamento` DISABLE KEYS */;
INSERT INTO `pagamento` VALUES (1,1,75.00),(2,1,175.00),(3,2,114.00),(4,2,266.00),(5,3,90.00),(6,4,135.00),(7,5,189.00),(8,6,222.00),(9,7,114.00),(10,7,266.00),(11,7,40.00);
/*!40000 ALTER TABLE `pagamento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `peca_produto`
--

DROP TABLE IF EXISTS `peca_produto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `peca_produto` (
  `id_peca` int NOT NULL AUTO_INCREMENT,
  `codigo_unico` varchar(50) NOT NULL,
  `descricao` varchar(150) NOT NULL,
  `tamanho` varchar(10) NOT NULL,
  `cor` varchar(30) NOT NULL,
  `material` varchar(50) DEFAULT NULL,
  `preco` decimal(10,2) NOT NULL,
  `sexo` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id_peca`),
  UNIQUE KEY `codigo_unico` (`codigo_unico`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `peca_produto`
--

LOCK TABLES `peca_produto` WRITE;
/*!40000 ALTER TABLE `peca_produto` DISABLE KEYS */;
INSERT INTO `peca_produto` VALUES (1,'TRJ-001','Terno Slim Fit Completo','M','Preto','Lã Fria',250.00,'Masculino'),(2,'TRJ-002','Vestido de Gala Sereia','P','Vermelho','Seda',380.00,'Feminino'),(3,'TRJ-003','Smoking Tradicional com Gravata Borboleta','G','Azul Marinho','Poliéster',300.00,'Masculino'),(4,'TRJ-004','Vestido Longo Tomara que Caia','M','Azul Serenity','Cetim',420.00,'Feminino'),(5,'TRJ-005','Terno Risca de Giz','G','Cinza Chumbo','Lã Fria',280.00,'Masculino'),(6,'TRJ-006','Vestido de Debutante com Saia Rodada','P','Rosa Bebê','Tule',450.00,'Feminino'),(7,'TRJ-007','Fraque Clássico','GG','Preto','Casimira',350.00,'Masculino'),(8,'TRJ-008','Vestido de Madrinha Longo','M','Verde Esmeralda','Crepe',320.00,'Feminino');
/*!40000 ALTER TABLE `peca_produto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `status_peca`
--

DROP TABLE IF EXISTS `status_peca`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `status_peca` (
  `id_status` int NOT NULL AUTO_INCREMENT,
  `descricao` varchar(50) NOT NULL,
  PRIMARY KEY (`id_status`),
  UNIQUE KEY `descricao` (`descricao`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `status_peca`
--

LOCK TABLES `status_peca` WRITE;
/*!40000 ALTER TABLE `status_peca` DISABLE KEYS */;
INSERT INTO `status_peca` VALUES (1,'Disponível'),(3,'Em ajuste'),(4,'Em lavanderia'),(5,'Em manutenção'),(2,'Reservada');
/*!40000 ALTER TABLE `status_peca` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `id_usuario` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `senha` varchar(255) NOT NULL,
  `perfil_acesso` varchar(50) NOT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,'Carlos Andrade','carlos.admin@trajeloc.com','admin123','ADMINISTRADOR'),(2,'Mariana Lima','mariana.func@trajeloc.com','func123','FUNCIONARIO'),(3,'Juliana Mendes','juliana.func@trajeloc.com','func123','FUNCIONARIO'),(4,'Gerson Nogueira','gerson.func@trajeloc.com','func123','FUNCIONARIO'),(5,'Roberto Alves','roberto.cliente@gmail.com','client123','CLIENTE'),(6,'Fernanda Costa','fernanda.cliente@gmail.com','client123','CLIENTE'),(7,'Lucas Santos','lucas.cliente@gmail.com','client123','CLIENTE'),(8,'Patrícia Rocha','patricia.func@trajeloc.com','func123','FUNCIONARIO'),(9,'Ana Beatriz Moura','anabeatriz.moura@gmail.com','client123','CLIENTE'),(10,'Rafael Teixeira','rafael.teixeira@outlook.com','client123','CLIENTE');
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'trajeloc'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-19 22:06:15
