create database ProjetoFinal;

use ProjetoFinal;

CREATE TABLE Cliente
(
    idCliente INT IDENTITY (1,1) PRIMARY KEY,
    nome      NVARCHAR(100) NOT NULL,
    cidade    NVARCHAR(100),
    numero int,
    codPostal VARCHAR(20),
    CC        VARCHAR(20)
);

CREATE TABLE Categoria(
    idcategoria int identity(1,1) primary key,
    nome nvarchar(100)
);

CREATE TABLE Produto(
    idproduto INT IDENTITY(1,1) PRIMARY KEY,
    categoria INT NOT NULL,
    nome      VARCHAR(100) NOT NULL,
    preco     DECIMAL(10,2) NOT NULL,

 --FK para CATEGORIA
      CONSTRAINT FK_PRODUTO_CATEGORIA
      FOREIGN KEY (categoria) REFERENCES Categoria(idcategoria)
);

CREATE TABLE Venda (
   idVenda INT IDENTITY(1,1) PRIMARY KEY,
   cliente INT NOT NULL,
   data DATE NOT NULL,
   desconto DECIMAL(5,2),

   CONSTRAINT FK_Venda_Cliente
       FOREIGN KEY (cliente) REFERENCES Cliente(idCliente),
);

CREATE TABLE LinhaVenda (
    venda   INT NOT NULL,
    produto INT NOT NULL,
    quantidade INT NOT NULL,

    -- PK composta
    CONSTRAINT PK_LinhaVenda PRIMARY KEY (venda),

    -- FK para Venda
    CONSTRAINT FK_LinhaVenda_Venda
        FOREIGN KEY (venda) REFERENCES Venda(idVenda),

    CONSTRAINT FK_LinhaVenda_Produto
       FOREIGN KEY (produto) REFERENCES Produto(idproduto)

);

DBCC CHECKIDENT ('Categoria', RESEED, 0);
DBCC CHECKIDENT ('Cliente', RESEED, 0);
DBCC CHECKIDENT ('Produto', RESEED, 0);
DBCC CHECKIDENT ('Venda', RESEED, 0);

INSERT INTO Categoria(nome)  VALUES('Jornais/Revistas'),
                                   ('Jogos de Tabulerio'),
                                   ('Raspadinhas'),
                                   ('Jogos Santa Casa'),
                                   ('Colecionáveis');

INSERT INTO Cliente(nome, cidade, numero, codPostal, CC) Values ('Chico Neto', 'Rio Tinto', '915531494', '3400-677', '25265748'),
                                                                ('Joaquim Neves', 'Águas-Santas', '918593223', '4425-001', '35527272'),
                                                                ('Diogo Pereira', 'Recarei Sobreira', '918847321', '4585-856', '98837183'),
                                                                ('Guilherme Santos', 'Valongo', '917547823', '4440-567', '85644473'),
                                                                ('Felipe Miranda', 'Ermesinde', '927392313', '4425-165', '67684732');

INSERT INTO Produto(categoria, nome, preco) VALUES ('1', 'Jornal de Negócios', '0.30'),
                                                   ('2', 'Dominó', '5.99'),
                                                   ('3', 'Rock da Sorte', '3.00'),
                                                   ('3', 'Génio do Deserto', '3.00'),
                                                   ('5', 'Carro de Corrida', '24.99'),
                                                   ('5', 'Carro da Polícia', '29.99'),
                                                   ('4', 'EuroMilhões', '2.20'),
                                                   ('1', 'Expresso', '0.40');

INSERT INTO Venda(cliente, data, desconto) VALUES ('2', '2025-04-23', '0'),
                                                  ('3', '2025-06-17', '10'),
                                                  ('4', '2025-05-19', '5'),
                                                  ('5', '2025-04-22', '10'),
                                                  ('3', '2025-03-04', '0'),
                                                  ('1', '2025-07-10', '20');

INSERT INTO LinhaVenda(venda, produto, quantidade) VALUES ('1', '3', '3'),
                                                          ('2', '4', '1'),
                                                          ('3', '2', '2'),
                                                          ('4', '1', '1'),
                                                          ('5', '5', '3'),
                                                          ('6', '6', '1');

SELECT nome, cidade
FROM Cliente;

SELECT *
FROM Cliente
WHERE cidade = 'Ermesinde';

SELECT *
FROM Cliente
WHERE nome LIKE 'D%';

SELECT
    COUNT(*) AS total_produtos,
    AVG(preco) AS preco_medio,
    MIN(preco) AS preco_minimo,
    MAX(preco) AS preco_maximo
FROM Produto;

SELECT p.nome, SUM(lv.quantidade) AS total_vendido
FROM LinhaVenda lv
JOIN Produto p ON p.idproduto = lv.produto
GROUP BY p.nome;

SELECT p.nome, SUM(lv.quantidade) AS total_vendido
FROM LinhaVenda lv
JOIN Produto p ON p.idproduto = lv.produto
GROUP BY p.nome
HAVING SUM(lv.quantidade) > 2;

SELECT v.idVenda, c.nome, v.data, v.desconto
FROM Venda v
INNER JOIN Cliente c ON c.idCliente = v.cliente;

SELECT p.nome, lv.quantidade
FROM Produto p
LEFT JOIN LinhaVenda lv ON lv.produto = p.idproduto;

SELECT v.idVenda, c.nome
FROM Venda v
RIGHT JOIN Cliente c ON c.idCliente = v.cliente;

SELECT
    v.idVenda,
    c.nome AS cliente,
    p.nome AS produto,
    lv.quantidade,
    v.data
FROM Venda v
JOIN Cliente c ON c.idCliente = v.cliente
JOIN LinhaVenda lv ON lv.venda = v.idVenda
JOIN Produto p ON p.idproduto = lv.produto;

SELECT *
FROM Cliente
WHERE idCliente NOT IN (SELECT cliente FROM Venda);

SELECT *
FROM Produto
WHERE preco > (SELECT AVG(preco) FROM Produto);

SELECT *
FROM Produto
WHERE idproduto NOT IN (SELECT produto FROM LinhaVenda);

SELECT DISTINCT cidade
FROM Cliente;

SELECT nome
FROM Produto
WHERE categoria = 1

UNION

SELECT nome
FROM Produto
WHERE categoria = 5;

CREATE VIEW Preco_Maior_1 AS
SELECT nome, preco
FROM Produto
WHERE preco > 1;

SELECT * FROM Preco_Maior_1;








