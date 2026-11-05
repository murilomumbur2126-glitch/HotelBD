DROP DATABASE IF EXISTS HotelDB;

CREATE DATABASE HotelDB;
USE HotelDB;

-- =========================================
-- TABELA: HOSPEDES
-- =========================================
CREATE TABLE Hospedes (
    idHospede INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome VARCHAR(125) NOT NULL,
    CPF VARCHAR(11) NOT NULL UNIQUE,
    telefone VARCHAR(11),
    temPet BOOLEAN NOT NULL DEFAULT FALSE,
    status VARCHAR(30) NOT NULL DEFAULT 'Ativo',

    PRIMARY KEY (idHospede)
);

-- =========================================
-- TABELA: QUARTOS
-- =========================================
CREATE TABLE Quartos (
    idQuarto INT UNSIGNED NOT NULL AUTO_INCREMENT,
    numeroQuarto INT NOT NULL,
    numeroAndar INT NOT NULL,
    ocupacaoMax INT NOT NULL,
    aceitaPet BOOLEAN NOT NULL DEFAULT FALSE,
    disponivel BOOLEAN NOT NULL DEFAULT TRUE,
    descricao VARCHAR(255),
    valorQuarto DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (idQuarto),
    UNIQUE (numeroQuarto, numeroAndar)
);

-- =========================================
-- TABELA: RESERVA
-- =========================================
CREATE TABLE Reserva (
    idReserva INT UNSIGNED NOT NULL AUTO_INCREMENT,
    dataEntrada DATE NOT NULL,
    dataSaida DATE NOT NULL,
    pagamento VARCHAR(50) NOT NULL,
    valor DECIMAL(10,2) NOT NULL,

    idHospede INT UNSIGNED NOT NULL,
    idQuarto INT UNSIGNED NOT NULL,

    PRIMARY KEY (idReserva),

    CONSTRAINT fk_reserva_hospede
        FOREIGN KEY (idHospede)
        REFERENCES Hospedes(idHospede),

    CONSTRAINT fk_reserva_quarto
        FOREIGN KEY (idQuarto)
        REFERENCES Quartos(idQuarto),

    CHECK (dataSaida > dataEntrada),
    CHECK (valor >= 0)
);

-- =========================================
-- CADASTRANDO HOSPEDES
-- =========================================
INSERT INTO Hospedes
(nome, CPF, telefone, temPet, status)
VALUES
('Carlos Eduardo Silva', '12345678901',
 '84999990001', FALSE, 'Ativo'),
('Maria Fernanda Oliveira', '12345678902',
 '84999990002', TRUE, 'Ativo'),
('Joao Pedro Santos', '12345678903',
 '84999990003', FALSE, 'Ativo');

-- =========================================
-- CADASTRANDO QUARTOS
-- =========================================
INSERT INTO Quartos
(numeroQuarto, numeroAndar, ocupacaoMax,
 aceitaPet, disponivel, descricao, valorQuarto)
VALUES
(101, 1, 2, FALSE, TRUE,
 'Quarto duplo', 180.00),
(102, 1, 3, TRUE, TRUE,
 'Quarto com capacidade para tres hospedes', 250.00),
(201, 2, 4, TRUE, TRUE,
 'Quarto familiar', 350.00);

-- =========================================
-- CADASTRANDO RESERVAS
-- =========================================
INSERT INTO Reserva
(dataEntrada, dataSaida, pagamento, valor,
 idHospede, idQuarto)
VALUES
('2026-11-01', '2026-11-03', 'Cartao', 360.00, 1, 1),
('2026-11-05', '2026-11-08', 'PIX', 750.00, 2, 2),
('2026-11-10', '2026-11-12', 'Dinheiro', 700.00, 3, 3);

-- =========================================
-- CONSULTA 1: TODOS OS HOSPEDES
-- =========================================
SELECT * FROM Hospedes;

-- =========================================
-- CONSULTA 2: TODOS OS QUARTOS
-- =========================================
SELECT * FROM Quartos;

-- =========================================
-- CONSULTA 3: TODAS AS RESERVAS
-- =========================================
SELECT * FROM Reserva;

-- =========================================
-- CONSULTA 4: RESERVAS COM HOSPEDE E QUARTO
-- INNER JOIN
-- =========================================
SELECT
    r.idReserva AS 'Codigo da Reserva',
    h.nome AS 'Nome do Hospede',
    q.numeroQuarto AS 'Numero do Quarto',
    r.dataEntrada AS 'Entrada',
    r.dataSaida AS 'Saida',
    r.pagamento AS 'Pagamento',
    r.valor AS 'Valor Total'
FROM Reserva r
INNER JOIN Hospedes h
    ON r.idHospede = h.idHospede
INNER JOIN Quartos q
    ON r.idQuarto = q.idQuarto;

-- =========================================
-- CONSULTA 5: TODOS OS HOSPEDES,
-- INCLUSIVE OS QUE NAO FIZERAM RESERVAS
-- LEFT JOIN
-- =========================================
SELECT
    h.idHospede AS 'Codigo do Hospede',
    h.nome AS 'Nome',
    r.idReserva AS 'Codigo da Reserva'
FROM Hospedes h
LEFT JOIN Reserva r
    ON h.idHospede = r.idHospede;

-- =========================================
-- CONSULTA 6: QUARTOS DISPONIVEIS
-- =========================================
SELECT *
FROM Quartos
WHERE disponivel = TRUE;
