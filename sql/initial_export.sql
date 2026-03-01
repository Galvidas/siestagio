-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Nov 04, 2025 at 12:17 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `siestagio`
--
CREATE DATABASE IF NOT EXISTS `siestagio` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `siestagio`;

-- --------------------------------------------------------

--
-- Table structure for table `Administrativo`
--

DROP TABLE IF EXISTS `Administrativo`;
CREATE TABLE IF NOT EXISTS `Administrativo` (
  `id` int(11) NOT NULL,
  `nome` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `Administrativo`:
--   `id`
--       `Utilizador` -> `id`
--

-- --------------------------------------------------------

--
-- Table structure for table `Aluno`
--

DROP TABLE IF EXISTS `Aluno`;
CREATE TABLE IF NOT EXISTS `Aluno` (
  `id` int(11) NOT NULL,
  `numero` int(11) NOT NULL,
  `nome` varchar(255) NOT NULL,
  `obs` text DEFAULT NULL,
  `administrativo_id` int(11) NOT NULL,
  `turma_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_Aluno_numero` (`numero`),
  KEY `FK_Aluno_Turma` (`turma_id`),
  KEY `ix_Aluno_registado_por` (`administrativo_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `Aluno`:
--   `administrativo_id`
--       `Administrativo` -> `id`
--   `turma_id`
--       `Turma` -> `id`
--   `id`
--       `Utilizador` -> `id`
--

--
-- Triggers `Aluno`
--
DROP TRIGGER IF EXISTS `TRG_Aluno_del_min10`;
DELIMITER $$
CREATE TRIGGER `TRG_Aluno_del_min10` BEFORE DELETE ON `Aluno` FOR EACH ROW BEGIN
  DECLARE cnt INT;
  DECLARE d   INT;

  -- lock target turma (now uses Turma.id)
  SELECT id INTO d
  FROM Turma
  WHERE id = OLD.turma_id
  FOR UPDATE;

  SELECT COUNT(*) INTO cnt
  FROM Aluno
  WHERE turma_id = OLD.turma_id;

  IF cnt <= 10 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Não pode ficar com < 10 alunos';
  END IF;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `TRG_Aluno_ins_max28`;
DELIMITER $$
CREATE TRIGGER `TRG_Aluno_ins_max28` BEFORE INSERT ON `Aluno` FOR EACH ROW BEGIN
  DECLARE cnt   INT;
  DECLARE dummy INT;

  SELECT id INTO dummy
  FROM Turma
  WHERE id = NEW.turma_id
  FOR UPDATE;

  SELECT COUNT(*) INTO cnt
  FROM Aluno
  WHERE turma_id = NEW.turma_id;

  IF cnt >= 28 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Turma cheia (máx. 28 alunos)';
  END IF;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `TRG_Aluno_upd_move_10_28`;
DELIMITER $$
CREATE TRIGGER `TRG_Aluno_upd_move_10_28` BEFORE UPDATE ON `Aluno` FOR EACH ROW BEGIN
  DECLARE cnt_from INT;
  DECLARE cnt_to   INT;
  DECLARE d        INT;

  IF NEW.turma_id <> OLD.turma_id THEN
    -- lock both turmas in a consistent order to avoid deadlock
    IF OLD.turma_id < NEW.turma_id THEN
      SELECT id INTO d FROM Turma WHERE id = OLD.turma_id FOR UPDATE;
      SELECT id INTO d FROM Turma WHERE id = NEW.turma_id FOR UPDATE;
    ELSE
      SELECT id INTO d FROM Turma WHERE id = NEW.turma_id FOR UPDATE;
      SELECT id INTO d FROM Turma WHERE id = OLD.turma_id FOR UPDATE;
    END IF;

    SELECT COUNT(*) INTO cnt_from FROM Aluno WHERE turma_id = OLD.turma_id;
    SELECT COUNT(*) INTO cnt_to   FROM Aluno WHERE turma_id = NEW.turma_id;

    IF cnt_from <= 10 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A turma de origem ficaria com < 10';
    END IF;

    IF cnt_to >= 28 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A turma de destino já tem 28';
    END IF;
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `AnoLetivo`
--

DROP TABLE IF EXISTS `AnoLetivo`;
CREATE TABLE IF NOT EXISTS `AnoLetivo` (
  `id` int(11) NOT NULL,
  `etiqueta` varchar(64) NOT NULL,
  `data_inicio` date DEFAULT NULL,
  `data_fim` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `AnoLetivo`:
--

-- --------------------------------------------------------

--
-- Table structure for table `AvaliacaoAnualEstab`
--

DROP TABLE IF EXISTS `AvaliacaoAnualEstab`;
CREATE TABLE IF NOT EXISTS `AvaliacaoAnualEstab` (
  `estabelecimento_id` int(11) NOT NULL,
  `anoletivo_id` int(11) NOT NULL,
  `id` int(11) NOT NULL,
  `avaliacao_id` int(11) DEFAULT NULL,
  `media` double DEFAULT NULL,
  `n_ratings` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_aae_estab_ano` (`estabelecimento_id`,`anoletivo_id`),
  KEY `FK_AvaliacaoAnualEstab_de_ano_AnoLetivo` (`anoletivo_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `AvaliacaoAnualEstab`:
--   `anoletivo_id`
--       `AnoLetivo` -> `id`
--   `estabelecimento_id`
--       `Estabelecimento` -> `estab_id`
--   `anoletivo_id`
--       `AnoLetivo` -> `id`
--

-- --------------------------------------------------------

--
-- Table structure for table `CAE`
--

DROP TABLE IF EXISTS `CAE`;
CREATE TABLE IF NOT EXISTS `CAE` (
  `id` int(11) NOT NULL,
  `codigo` varchar(32) NOT NULL,
  `descricao` varchar(255) NOT NULL,
  `administrativo_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_CAE_registado_por` (`administrativo_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `CAE`:
--   `administrativo_id`
--       `Administrativo` -> `id`
--

-- --------------------------------------------------------

--
-- Table structure for table `Curso`
--

DROP TABLE IF EXISTS `Curso`;
CREATE TABLE IF NOT EXISTS `Curso` (
  `id` int(11) NOT NULL,
  `codigo` varchar(64) NOT NULL,
  `designacao` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `Curso`:
--

-- --------------------------------------------------------

--
-- Table structure for table `Disciplina`
--

DROP TABLE IF EXISTS `Disciplina`;
CREATE TABLE IF NOT EXISTS `Disciplina` (
  `id` int(11) NOT NULL,
  `nome` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `Disciplina`:
--

-- --------------------------------------------------------

--
-- Table structure for table `DisponibilidadeEmpresa`
--

DROP TABLE IF EXISTS `DisponibilidadeEmpresa`;
CREATE TABLE IF NOT EXISTS `DisponibilidadeEmpresa` (
  `empresa_id` int(11) NOT NULL,
  `anoletivo_id` int(11) NOT NULL,
  `id` int(11) NOT NULL,
  `disponibilidade_id` int(11) DEFAULT NULL,
  `disponivel` tinyint(1) NOT NULL,
  `capacidade` int(11) NOT NULL,
  PRIMARY KEY (`empresa_id`,`id`),
  UNIQUE KEY `UQ_DisponibilidadeEmpresa_Ano` (`empresa_id`,`anoletivo_id`),
  KEY `FK_DisponibilidadeEmpresa_para_ano_AnoLetivo` (`anoletivo_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `DisponibilidadeEmpresa`:
--   `anoletivo_id`
--       `AnoLetivo` -> `id`
--   `empresa_id`
--       `Empresa` -> `id`
--

--
-- Triggers `DisponibilidadeEmpresa`
--
DROP TRIGGER IF EXISTS `TRG_Disponibilidade_capacidade_chk`;
DELIMITER $$
CREATE TRIGGER `TRG_Disponibilidade_capacidade_chk` BEFORE INSERT ON `DisponibilidadeEmpresa` FOR EACH ROW BEGIN
  IF NEW.capacidade < 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='capacidade não pode ser negativa';
  END IF;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `TRG_Disponibilidade_capacidade_chk_upd`;
DELIMITER $$
CREATE TRIGGER `TRG_Disponibilidade_capacidade_chk_upd` BEFORE UPDATE ON `DisponibilidadeEmpresa` FOR EACH ROW BEGIN
  IF NEW.capacidade < 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='capacidade não pode ser negativa';
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `Empresa`
--

DROP TABLE IF EXISTS `Empresa`;
CREATE TABLE IF NOT EXISTS `Empresa` (
  `id` int(11) NOT NULL,
  `firma` varchar(255) NOT NULL,
  `nif` varchar(32) NOT NULL,
  `sede_morada` text DEFAULT NULL,
  `localidade` text DEFAULT NULL,
  `cod_postal` text DEFAULT NULL,
  `telefone` text DEFAULT NULL,
  `email` text DEFAULT NULL,
  `website` text DEFAULT NULL,
  `obs` text DEFAULT NULL,
  `administrativo_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_Empresa_nif` (`nif`),
  KEY `ix_Empresa_registado_por` (`administrativo_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `Empresa`:
--   `administrativo_id`
--       `Administrativo` -> `id`
--

-- --------------------------------------------------------

--
-- Table structure for table `Empresa_CAE`
--

DROP TABLE IF EXISTS `Empresa_CAE`;
CREATE TABLE IF NOT EXISTS `Empresa_CAE` (
  `empresa_id` int(11) NOT NULL,
  `cae_id` int(11) NOT NULL,
  PRIMARY KEY (`empresa_id`,`cae_id`),
  KEY `fk_empresa_cae_cae` (`cae_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `Empresa_CAE`:
--   `cae_id`
--       `CAE` -> `id`
--   `empresa_id`
--       `Empresa` -> `id`
--

--
-- Triggers `Empresa_CAE`
--
DROP TRIGGER IF EXISTS `TRG_Empresa_CAE_no_last`;
DELIMITER $$
CREATE TRIGGER `TRG_Empresa_CAE_no_last` BEFORE DELETE ON `Empresa_CAE` FOR EACH ROW begin
  declare cnt int;
  select count(*) into cnt
  from Empresa_CAE
  where Empresa_ID = old.Empresa_ID;
  if cnt <= 1 then
    signal sqlstate '45000' set message_text = 'Empresa tem de ter pelo menos um CAE';
  end if;
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `Estabelecimento`
--

DROP TABLE IF EXISTS `Estabelecimento`;
CREATE TABLE IF NOT EXISTS `Estabelecimento` (
  `empresa_id` int(11) NOT NULL,
  `id` int(11) NOT NULL,
  `estab_id` int(11) NOT NULL,
  `nome_comercial` text DEFAULT NULL,
  `morada` text DEFAULT NULL,
  `localidade` text DEFAULT NULL,
  `cod_postal` text DEFAULT NULL,
  `telefone` text DEFAULT NULL,
  `email` text DEFAULT NULL,
  `foto` text DEFAULT NULL,
  `horario` text DEFAULT NULL,
  `data_fundacao` date DEFAULT NULL,
  `obs` text DEFAULT NULL,
  `aceitou_estagiarios` tinyint(1) DEFAULT NULL,
  `administrativo_id` int(11) NOT NULL,
  `zona_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`empresa_id`,`id`),
  UNIQUE KEY `uq_estabelecimento_estab_id` (`estab_id`),
  KEY `FK_Estabelecimento_Zona` (`zona_id`),
  KEY `ix_Estab_registado_por` (`administrativo_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `Estabelecimento`:
--   `administrativo_id`
--       `Administrativo` -> `id`
--   `empresa_id`
--       `Empresa` -> `id`
--   `zona_id`
--       `Zona` -> `id`
--

-- --------------------------------------------------------

--
-- Table structure for table `Estab_Produto`
--

DROP TABLE IF EXISTS `Estab_Produto`;
CREATE TABLE IF NOT EXISTS `Estab_Produto` (
  `estabelecimento_id` int(11) NOT NULL,
  `id` int(11) NOT NULL,
  `produto_id` int(11) NOT NULL,
  `principal` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `FK_Estab_Produto_Produto` (`produto_id`),
  KEY `fk_estab_prod__estabelecimento` (`estabelecimento_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `Estab_Produto`:
--   `estabelecimento_id`
--       `Estabelecimento` -> `estab_id`
--   `produto_id`
--       `Produto` -> `id`
--

-- --------------------------------------------------------

--
-- Table structure for table `Estab_Transporte`
--

DROP TABLE IF EXISTS `Estab_Transporte`;
CREATE TABLE IF NOT EXISTS `Estab_Transporte` (
  `empresa_id` int(11) NOT NULL,
  `estabelecimento_id` int(11) NOT NULL,
  `transporte_id` int(11) NOT NULL,
  `id` int(11) NOT NULL,
  `estab_transp_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_Estab_Transporte_unique` (`empresa_id`,`estabelecimento_id`,`transporte_id`),
  KEY `fk_estab_transp_transporte` (`transporte_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `Estab_Transporte`:
--   `empresa_id`
--       `Estabelecimento` -> `empresa_id`
--   `estabelecimento_id`
--       `Estabelecimento` -> `id`
--   `transporte_id`
--       `Transporte` -> `id`
--

-- --------------------------------------------------------

--
-- Table structure for table `Estagio`
--

DROP TABLE IF EXISTS `Estagio`;
CREATE TABLE IF NOT EXISTS `Estagio` (
  `aluno_id` int(11) NOT NULL,
  `formador_id` int(11) NOT NULL,
  `responsavel_id` int(11) NOT NULL,
  `id` int(11) NOT NULL,
  `dt_inicio` date DEFAULT NULL,
  `dt_fim` date DEFAULT NULL,
  `nota_empresa` int(11) DEFAULT NULL,
  `nota_escola` int(11) DEFAULT NULL,
  `nota_procura` int(11) DEFAULT NULL,
  `nota_relatorio` int(11) DEFAULT NULL,
  `classificacao_local` int(11) DEFAULT NULL,
  `empresa_id` int(11) NOT NULL,
  `estabelecimento_id` int(11) NOT NULL,
  `nota_final` decimal(5,2) GENERATED ALWAYS AS (case when `nota_empresa` is not null and `nota_escola` is not null and `nota_procura` is not null and `nota_relatorio` is not null then round((`nota_empresa` + `nota_escola` + `nota_procura` + `nota_relatorio`) / 4,2) end) STORED,
  PRIMARY KEY (`id`),
  KEY `fk_estagio_aluno` (`aluno_id`),
  KEY `fk_estagio_formador` (`formador_id`),
  KEY `fk_estagio_responsavel_mesmo_estab` (`empresa_id`,`estabelecimento_id`,`responsavel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `Estagio`:
--   `aluno_id`
--       `Aluno` -> `id`
--   `formador_id`
--       `Formador` -> `id`
--   `empresa_id`
--       `Estabelecimento` -> `empresa_id`
--   `estabelecimento_id`
--       `Estabelecimento` -> `id`
--   `empresa_id`
--       `Responsavel` -> `empresa_id`
--   `estabelecimento_id`
--       `Responsavel` -> `estabelecimento_id`
--   `responsavel_id`
--       `Responsavel` -> `id`
--

--
-- Triggers `Estagio`
--
DROP TRIGGER IF EXISTS `TRG_Estagio_chk_ins`;
DELIMITER $$
CREATE TRIGGER `TRG_Estagio_chk_ins` BEFORE INSERT ON `Estagio` FOR EACH ROW BEGIN
  IF NEW.dt_inicio IS NOT NULL AND NEW.dt_fim IS NOT NULL AND NEW.dt_fim < NEW.dt_inicio THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='dt_fim < dt_inicio';
  END IF;

  IF NEW.nota_empresa  IS NOT NULL AND (NEW.nota_empresa  < 0 OR NEW.nota_empresa  > 20) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='nota_empresa fora [0,20]';
  END IF;
  IF NEW.nota_escola   IS NOT NULL AND (NEW.nota_escola   < 0 OR NEW.nota_escola   > 20) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='nota_escola fora [0,20]';
  END IF;
  IF NEW.nota_procura  IS NOT NULL AND (NEW.nota_procura  < 0 OR NEW.nota_procura  > 20) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='nota_procura fora [0,20]';
  END IF;
  IF NEW.nota_relatorio IS NOT NULL AND (NEW.nota_relatorio < 0 OR NEW.nota_relatorio > 20) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='nota_relatorio fora [0,20]';
  END IF;

  IF NEW.classificacao_local IS NOT NULL AND (NEW.classificacao_local < 1 OR NEW.classificacao_local > 5) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='classificacao_local fora [1,5]';
  END IF;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `TRG_Estagio_chk_upd`;
DELIMITER $$
CREATE TRIGGER `TRG_Estagio_chk_upd` BEFORE UPDATE ON `Estagio` FOR EACH ROW BEGIN
  IF NEW.dt_inicio IS NOT NULL AND NEW.dt_fim IS NOT NULL AND NEW.dt_fim < NEW.dt_inicio THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='dt_fim < dt_inicio';
  END IF;
  -- repetir os mesmos checks das notas e classificação do trigger de INSERT
  IF NEW.nota_empresa  IS NOT NULL AND (NEW.nota_empresa  < 0 OR NEW.nota_empresa  > 20) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='nota_empresa fora [0,20]';
  END IF;
  IF NEW.nota_escola   IS NOT NULL AND (NEW.nota_escola   < 0 OR NEW.nota_escola   > 20) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='nota_escola fora [0,20]';
  END IF;
  IF NEW.nota_procura  IS NOT NULL AND (NEW.nota_procura  < 0 OR NEW.nota_procura  > 20) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='nota_procura fora [0,20]';
  END IF;
  IF NEW.nota_relatorio IS NOT NULL AND (NEW.nota_relatorio < 0 OR NEW.nota_relatorio > 20) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='nota_relatorio fora [0,20]';
  END IF;

  IF NEW.classificacao_local IS NOT NULL AND (NEW.classificacao_local < 1 OR NEW.classificacao_local > 5) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='classificacao_local fora [1,5]';
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `Formador`
--

DROP TABLE IF EXISTS `Formador`;
CREATE TABLE IF NOT EXISTS `Formador` (
  `id` int(11) NOT NULL,
  `disciplina_id` int(11) NOT NULL,
  `numero` int(11) DEFAULT NULL,
  `nome` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_Formador_leciona_Disciplina` (`disciplina_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `Formador`:
--   `disciplina_id`
--       `Disciplina` -> `id`
--   `id`
--       `Utilizador` -> `id`
--

-- --------------------------------------------------------

--
-- Table structure for table `Marca`
--

DROP TABLE IF EXISTS `Marca`;
CREATE TABLE IF NOT EXISTS `Marca` (
  `id` int(11) NOT NULL,
  `nome` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_Marca_nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `Marca`:
--

-- --------------------------------------------------------

--
-- Table structure for table `Produto`
--

DROP TABLE IF EXISTS `Produto`;
CREATE TABLE IF NOT EXISTS `Produto` (
  `marca_id` int(11) NOT NULL,
  `id` int(11) NOT NULL,
  `nome` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_Produto_marca_nome` (`marca_id`,`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `Produto`:
--   `marca_id`
--       `Marca` -> `id`
--

-- --------------------------------------------------------

--
-- Table structure for table `Responsavel`
--

DROP TABLE IF EXISTS `Responsavel`;
CREATE TABLE IF NOT EXISTS `Responsavel` (
  `empresa_id` int(11) NOT NULL,
  `estabelecimento_id` int(11) NOT NULL,
  `id` int(11) NOT NULL,
  `resp_id` int(11) DEFAULT NULL,
  `nome` varchar(255) NOT NULL,
  `titulo` text DEFAULT NULL,
  `cargo` text DEFAULT NULL,
  `tel_direto` text DEFAULT NULL,
  `telemovel` text DEFAULT NULL,
  `email` text DEFAULT NULL,
  `obs` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_Responsavel_por_estab` (`empresa_id`,`estabelecimento_id`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `Responsavel`:
--   `empresa_id`
--       `Estabelecimento` -> `empresa_id`
--   `estabelecimento_id`
--       `Estabelecimento` -> `id`
--

-- --------------------------------------------------------

--
-- Table structure for table `Transporte`
--

DROP TABLE IF EXISTS `Transporte`;
CREATE TABLE IF NOT EXISTS `Transporte` (
  `id` int(11) NOT NULL,
  `transp_id` int(11) DEFAULT NULL,
  `meio` varchar(64) NOT NULL,
  `linha` varchar(64) NOT NULL,
  `obs` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_Transporte_meio_linha` (`meio`,`linha`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `Transporte`:
--

-- --------------------------------------------------------

--
-- Table structure for table `Turma`
--

DROP TABLE IF EXISTS `Turma`;
CREATE TABLE IF NOT EXISTS `Turma` (
  `curso_id` int(11) NOT NULL,
  `anoletivo_id` int(11) NOT NULL,
  `id` int(11) NOT NULL,
  `sigla` varchar(64) NOT NULL,
  `ano` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_Turma_sigla_por_ano` (`anoletivo_id`,`sigla`),
  KEY `FK_Turma_tem_Curso` (`curso_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `Turma`:
--   `anoletivo_id`
--       `AnoLetivo` -> `id`
--   `curso_id`
--       `Curso` -> `id`
--

--
-- Triggers `Turma`
--
DROP TRIGGER IF EXISTS `TRG_Turma_ano_chk`;
DELIMITER $$
CREATE TRIGGER `TRG_Turma_ano_chk` BEFORE INSERT ON `Turma` FOR EACH ROW BEGIN
  IF NEW.ano NOT IN (1,2,3) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Turma.ano deve ser 1, 2 ou 3';
  END IF;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `TRG_Turma_ano_chk_upd`;
DELIMITER $$
CREATE TRIGGER `TRG_Turma_ano_chk_upd` BEFORE UPDATE ON `Turma` FOR EACH ROW BEGIN
  IF NEW.ano NOT IN (1,2,3) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Turma.ano deve ser 1, 2 ou 3';
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `Utilizador`
--

DROP TABLE IF EXISTS `Utilizador`;
CREATE TABLE IF NOT EXISTS `Utilizador` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `login` varchar(191) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `nome` text DEFAULT NULL,
  `tipo` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_Utilizador_login` (`login`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `Utilizador`:
--

-- --------------------------------------------------------

--
-- Table structure for table `Zona`
--

DROP TABLE IF EXISTS `Zona`;
CREATE TABLE IF NOT EXISTS `Zona` (
  `id` int(11) NOT NULL,
  `designacao` text DEFAULT NULL,
  `localidade` text DEFAULT NULL,
  `mapa` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `Zona`:
--

-- --------------------------------------------------------

--
-- Table structure for table `Zona_Transporte`
--

DROP TABLE IF EXISTS `Zona_Transporte`;
CREATE TABLE IF NOT EXISTS `Zona_Transporte` (
  `zona_id` int(11) NOT NULL,
  `id` int(11) NOT NULL,
  `zona_transp_id` int(11) DEFAULT NULL,
  `transporte_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_Zona_Transporte_unique` (`zona_id`,`transporte_id`),
  KEY `FK_Zona_Transporte_Transporte` (`transporte_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `Zona_Transporte`:
--   `transporte_id`
--       `Transporte` -> `id`
--   `zona_id`
--       `Zona` -> `id`
--

--
-- Constraints for dumped tables
--

--
-- Constraints for table `Administrativo`
--
ALTER TABLE `Administrativo`
  ADD CONSTRAINT `fk_administrativo_utilizador` FOREIGN KEY (`id`) REFERENCES `Utilizador` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Aluno`
--
ALTER TABLE `Aluno`
  ADD CONSTRAINT `fk_aluno_admin` FOREIGN KEY (`administrativo_id`) REFERENCES `Administrativo` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_aluno_turma` FOREIGN KEY (`turma_id`) REFERENCES `Turma` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_aluno_utilizador` FOREIGN KEY (`id`) REFERENCES `Utilizador` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `AvaliacaoAnualEstab`
--
ALTER TABLE `AvaliacaoAnualEstab`
  ADD CONSTRAINT `fk_aae_ano` FOREIGN KEY (`anoletivo_id`) REFERENCES `AnoLetivo` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_aae_estabelecimento` FOREIGN KEY (`estabelecimento_id`) REFERENCES `Estabelecimento` (`estab_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_avaliacao_ano` FOREIGN KEY (`anoletivo_id`) REFERENCES `AnoLetivo` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `CAE`
--
ALTER TABLE `CAE`
  ADD CONSTRAINT `fk_cae_admin` FOREIGN KEY (`administrativo_id`) REFERENCES `Administrativo` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `DisponibilidadeEmpresa`
--
ALTER TABLE `DisponibilidadeEmpresa`
  ADD CONSTRAINT `fk_disp_ano` FOREIGN KEY (`anoletivo_id`) REFERENCES `AnoLetivo` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_disp_empresa` FOREIGN KEY (`empresa_id`) REFERENCES `Empresa` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Empresa`
--
ALTER TABLE `Empresa`
  ADD CONSTRAINT `fk_empresa_admin` FOREIGN KEY (`administrativo_id`) REFERENCES `Administrativo` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `Empresa_CAE`
--
ALTER TABLE `Empresa_CAE`
  ADD CONSTRAINT `fk_empresa_cae_cae` FOREIGN KEY (`cae_id`) REFERENCES `CAE` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_empresa_cae_emp` FOREIGN KEY (`empresa_id`) REFERENCES `Empresa` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Estabelecimento`
--
ALTER TABLE `Estabelecimento`
  ADD CONSTRAINT `fk_estab_admin` FOREIGN KEY (`administrativo_id`) REFERENCES `Administrativo` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_estab_empresa` FOREIGN KEY (`empresa_id`) REFERENCES `Empresa` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_estab_zona` FOREIGN KEY (`zona_id`) REFERENCES `Zona` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `Estab_Produto`
--
ALTER TABLE `Estab_Produto`
  ADD CONSTRAINT `fk_estab_prod__estabelecimento` FOREIGN KEY (`estabelecimento_id`) REFERENCES `Estabelecimento` (`estab_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_estab_prod_produto` FOREIGN KEY (`produto_id`) REFERENCES `Produto` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `Estab_Transporte`
--
ALTER TABLE `Estab_Transporte`
  ADD CONSTRAINT `fk_estab_transp_estab` FOREIGN KEY (`empresa_id`,`estabelecimento_id`) REFERENCES `Estabelecimento` (`empresa_id`, `id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_estab_transp_transporte` FOREIGN KEY (`transporte_id`) REFERENCES `Transporte` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `Estagio`
--
ALTER TABLE `Estagio`
  ADD CONSTRAINT `fk_estagio_aluno` FOREIGN KEY (`aluno_id`) REFERENCES `Aluno` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_estagio_formador` FOREIGN KEY (`formador_id`) REFERENCES `Formador` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_estagio_local` FOREIGN KEY (`empresa_id`,`estabelecimento_id`) REFERENCES `Estabelecimento` (`empresa_id`, `id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_estagio_responsavel_mesmo_estab` FOREIGN KEY (`empresa_id`,`estabelecimento_id`,`responsavel_id`) REFERENCES `Responsavel` (`empresa_id`, `estabelecimento_id`, `id`) ON UPDATE CASCADE;

--
-- Constraints for table `Formador`
--
ALTER TABLE `Formador`
  ADD CONSTRAINT `fk_formador_disciplina` FOREIGN KEY (`disciplina_id`) REFERENCES `Disciplina` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_formador_utilizador` FOREIGN KEY (`id`) REFERENCES `Utilizador` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Produto`
--
ALTER TABLE `Produto`
  ADD CONSTRAINT `fk_produto_marca` FOREIGN KEY (`marca_id`) REFERENCES `Marca` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `Responsavel`
--
ALTER TABLE `Responsavel`
  ADD CONSTRAINT `fk_responsavel_estab` FOREIGN KEY (`empresa_id`,`estabelecimento_id`) REFERENCES `Estabelecimento` (`empresa_id`, `id`) ON UPDATE CASCADE;

--
-- Constraints for table `Turma`
--
ALTER TABLE `Turma`
  ADD CONSTRAINT `fk_turma_anoletivo` FOREIGN KEY (`anoletivo_id`) REFERENCES `AnoLetivo` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_turma_curso` FOREIGN KEY (`curso_id`) REFERENCES `Curso` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `Zona_Transporte`
--
ALTER TABLE `Zona_Transporte`
  ADD CONSTRAINT `fk_zona_transp_transporte` FOREIGN KEY (`transporte_id`) REFERENCES `Transporte` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_zona_transp_zona` FOREIGN KEY (`zona_id`) REFERENCES `Zona` (`id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
