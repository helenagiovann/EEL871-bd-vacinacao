
-- ================================
-- CRIAÇÃO DAS TABELAS
-- ================================

CREATE TABLE Pessoa (
    ID_Pessoa INT PRIMARY KEY
);

CREATE TABLE Paciente (
    ID_Paciente INT PRIMARY KEY,
    CPF VARCHAR(14) NOT NULL UNIQUE,
    Nome VARCHAR(100),
    Data_Nasc DATE,
    FOREIGN KEY (ID_Paciente) REFERENCES Pessoa(ID_Pessoa)
);

CREATE TABLE Vacinador (
    ID_Vacinador INT PRIMARY KEY,
    Nome VARCHAR(100),
    Codigo VARCHAR(20),
    FOREIGN KEY (ID_Vacinador) REFERENCES Pessoa(ID_Pessoa)
);

CREATE TABLE Fabricante (
    ID_Fabricante INT PRIMARY KEY,
    Nome VARCHAR(100)
);

CREATE TABLE Vacina (
    ID_Vacina INT PRIMARY KEY,
    Nome VARCHAR(100),
    Tipo VARCHAR(50),
    ID_Fabricante INT,
    FOREIGN KEY (ID_Fabricante) REFERENCES Fabricante(ID_Fabricante)
);

CREATE TABLE Unidade_de_Saude (
    ID_Unidade INT PRIMARY KEY,
    Nome_Unidade VARCHAR(100)
);

CREATE TABLE Aplicacao (
    ID_Aplicacao INT PRIMARY KEY,
    Data DATE,
    Lote VARCHAR(50),
    Dose VARCHAR(10),
    Cod_Vacinador INT NOT NULL,
    ID_Paciente INT NOT NULL,
    ID_Vacina INT NOT NULL,
    ID_Unidade INT NOT NULL,
    Validade DATE,
    Quantidade INT,
    FOREIGN KEY (Cod_Vacinador) REFERENCES Vacinador(ID_Vacinador),
    FOREIGN KEY (ID_Paciente) REFERENCES Paciente(ID_Paciente),
    FOREIGN KEY (ID_Vacina) REFERENCES Vacina(ID_Vacina),
    FOREIGN KEY (ID_Unidade) REFERENCES Unidade_de_Saude(ID_Unidade)
);

-- ================================
-- INSERÇÃO DE DADOS
-- ================================

-- Fabricantes
INSERT INTO Fabricante VALUES 
(1, 'Pfizer'), (2, 'Moderna'), (3, 'Janssen'), (4, 'Sinovac'), (5, 'AstraZeneca');

-- Vacinas
INSERT INTO Vacina VALUES 
(1, 'Pfizer Adulto', 'mRNA', 1),
(2, 'Moderna Baby', 'mRNA', 2),
(3, 'Janssen Dose Única', 'Vetor Viral', 3),
(4, 'Coronavac', 'Inativada', 4),
(5, 'AstraZeneca Oxford', 'Vetor Viral', 5);

-- Pessoas
INSERT INTO Pessoa VALUES (10), (11), (12), (13), (14), (15), (16),(17),(18),(19);

-- Pacientes
INSERT INTO Paciente VALUES 
(10, '11111111111', 'Ana', '1990-01-01'),
(11, '22222222222', 'João', '1985-03-12'),
(12, '33333333333', 'Maria', '1970-08-19'),
(13, '44444444444', 'Pedro', '1995-06-06'),
(14, '55555555555', 'Luiza', '2001-09-09');

-- Vacinadores
INSERT INTO Vacinador VALUES 
(15, 'Carlos', 'VAC001'), (16, 'Fernanda', 'VAC002'),(17,'Fábio','VAC003'),(18, 'Joana', 'VAC004'),(19, 'Nina', 'VAC005');

-- Unidades de Saúde
INSERT INTO Unidade_de_Saude VALUES 
(1, 'Posto Central'),
(2, 'UBS Zona Sul'),
(3, 'Hospital Municipal'),
(4, 'Policlínica Norte'),
(5, 'Vacinação Móvel');

-- Aplicações
INSERT INTO Aplicacao VALUES 
(1, '2025-06-01', 'L001', '1ª', 15, 10, 1, 1, '2025-06-20', 50),
(2, '2025-06-01', 'L002', '1ª', 15, 11, 2, 2, '2025-05-15', 50),
(3, '2025-06-01', 'L003', 'Única', 16, 12, 3, 3, '2025-06-25', 50),
(4, '2025-06-01', 'L004', '2ª', 16, 13, 4, 4, '2025-06-10', 50),
(5, '2025-06-01', 'L005', '2ª', 15, 14, 5, 5, '2025-06-01', 50),
(6, '2025-06-10', 'L006', '1ª', 16, 10, 2, 2, '2025-06-30', 50),
(7, '2025-06-11', 'L007', 'Única', 17, 10, 3, 3, '2025-06-30', 50),
(8, '2025-06-12', 'L008', '2ª', 18, 10, 4, 4, '2025-06-30', 50),
(9, '2025-06-13', 'L009', '2ª', 19, 10, 5, 5, '2025-06-30', 50);


-- ================================
-- CONSTRAINT
-- ================================
ALTER TABLE Aplicacao
ADD CONSTRAINT CHK_Quantidade CHECK (Quantidade <= 100);

-- ================================
-- VIEW
-- ================================
CREATE VIEW V_Lotes_Vencidos AS
SELECT * FROM Aplicacao WHERE Validade < GETDATE();

-- ================================
-- STORED PROCEDURE
-- ================================
CREATE PROCEDURE SP_Pacientes_Vacina_Vencida AS
BEGIN
  SELECT DISTINCT p.Nome, a.Data, v.Nome AS Vacina
  FROM Aplicacao a
  JOIN Paciente p ON p.ID_Paciente = a.ID_Paciente
  JOIN Vacina v ON v.ID_Vacina = a.ID_Vacina
  WHERE a.Validade < a.Data;
END;

-- ================================
-- TRIGGER
-- ================================
CREATE TRIGGER TRG_DataAtualizacao
ON Aplicacao
AFTER INSERT
AS
BEGIN
  UPDATE Aplicacao
  SET Data = GETDATE()
  WHERE ID_Aplicacao IN (SELECT ID_Aplicacao FROM inserted);
END;

-- ================================
-- TABELA TEMPORÁRIA
-- ================================
CREATE TABLE ##Fabricantes_Temporarios (
  ID INT,
  Nome VARCHAR(100)
);
INSERT INTO ##Fabricantes_Temporarios SELECT * FROM Fabricante;

-- ================================
-- CURSOR
-- ================================
DECLARE @Data DATE, @Paciente VARCHAR(100), @Lote VARCHAR(50), @Fabricante VARCHAR(100);

DECLARE cursorVacinas CURSOR FOR
SELECT a.Data, p.Nome, a.Lote, f.Nome
FROM Aplicacao a
JOIN Paciente p ON p.ID_Paciente = a.ID_Paciente
JOIN Vacina v ON v.ID_Vacina = a.ID_Vacina
JOIN Fabricante f ON f.ID_Fabricante = v.ID_Fabricante;

OPEN cursorVacinas;
FETCH NEXT FROM cursorVacinas INTO @Data, @Paciente, @Lote, @Fabricante;

WHILE @@FETCH_STATUS = 0
BEGIN
  PRINT 'Data: ' + CONVERT(VARCHAR, @Data) + ', Paciente: ' + @Paciente + ', Lote: ' + @Lote + ', Fabricante: ' + @Fabricante;
  FETCH NEXT FROM cursorVacinas INTO @Data, @Paciente, @Lote, @Fabricante;
END

CLOSE cursorVacinas;
DEALLOCATE cursorVacinas;
