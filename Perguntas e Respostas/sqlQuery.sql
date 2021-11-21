--1.	Quem são os meus 10 maiores clientes, em termos de vendas ($)?
select idcliente, sum(vendas) as vendaTotal from (
	SELECT ped.idcliente, ped.idpedido, sum(it.vendas) as Vendas
	FROM Pedido ped
	INNER JOIN Item it ON ped.idpedido=it.idpedido 
	group by ped.idcliente, ped.idpedido
	order by ped.idcliente
) as resultado
group by resultado.idcliente order by vendaTotal desc limit 10

-- Resultado 1: 63, 19, 37, 23, 32, 1, 80, 44, 73 e 79;

--2.	Quais os três maiores países, em termos de vendas ($)?

select response.paisnome, sum(tabela.vendatotal) as sell
from (
	select ps.paisNome, cli.idcliente
	from Cliente cli Inner join Pais ps ON ps.idpais = cli.idpais order by cli.idcliente
) as response 
INNER JOIN (
		select idcliente, sum(vendas) as vendaTotal 
		from (
			SELECT ped.idcliente, ped.idpedido, sum(it.vendas) as Vendas
			FROM Pedido ped
			INNER JOIN Item it ON ped.idpedido=it.idpedido 
			group by ped.idcliente, ped.idpedido
			order by ped.idcliente
		) as resultado
		group by resultado.idcliente order by resultado.idcliente
) as tabela
ON response.idcliente = tabela.idcliente group by response.paisnome order by sell desc limit 3

-- Resultado 2: Germany, USA e France

--3.	Quais as categorias de produtos que 
--geram maior faturamento (vendas $) no Brasil?
select * from (
select (select paisNome from pais where idpais = cli.idpais), 
(select categoriaNome from categoria where idcategoria in 
 (select idcategoria from produto where idproduto = table1.idproduto)),
sum(table1.vendas) as vendasTotal
from cliente cli
inner join (
Select tabela1.idcliente, tabela2.idproduto, tabela2.vendas
from (select idpedido, idcliente from pedido) as tabela1
inner join (select idpedido, idproduto, vendas from item) tabela2
on tabela1.idpedido = tabela2.idpedido
) as table1
ON cli.idcliente = table1.idcliente 
group by paisnome, categorianome
order by vendastotal desc
) as table3 where paisnome = 'Brazil'

-- Resultado 3 (Ranking): 
	-- 1: Womens wear, 
	-- 2: Sportwear, 
	-- 3: Babywear, 
	-- 4: Men's Footwear
	-- 5: Ladies'Footwear
	-- 6: Men´s Clothes
	-- 7: Bath Clothes
	-- 8: Children´s wear

--4.	Qual a despesa com frete envolvendo cada transportadora?
select (select transportadoranome 
		from transportadora where idtransportadora = pd.idtransportadora),
		sum(pd.frete) as frete from pedido pd
group by pd.idtransportadora order by pd.idtransportadora

-- Resultado 4:
	-- General Shipping = 8447.63
	-- Global Express =  26886.73
	-- Great Logistics = 6602.78
	
--5.	Quais são os principais clientes (vendas $) do segmento 
--“Calçados Masculinos” (Men´s Footwear) na Alemanha?
select * from (
select cli.clientenome, table1.categoriaNome, table1.vendas, 
(select paisnome from pais where idpais = cli.idpais) 
from cliente as cli
Inner join (
	select pd.idcliente, 
	(select (select categorianome from categoria where idcategoria = pd.idcategoria)
	 from produto as pd where idproduto = it.idproduto)
	, sum(vendas) vendas
	from item as it
	INNER JOIN pedido pd ON it.idpedido = pd.idpedido
	group by idcliente, categorianome order by idcliente
) as table1
	ON table1.idcliente = cli.idcliente
) as resultado 
where resultado.paisnome = 'Germany' 
and resultado.categorianome = 'Men´s Footwear'
order by vendas desc

-- Resultado 5 (RANKING):
	-- 1: GruneWald
	-- 2: Gluderstedt
	-- 3: Boombastic
	-- 4: Eintrach Gs
	-- 5: Warp AG
	-- 6: Noch Einmal GMBH
	-- 7: Casual Clothing
	-- 8: Halle Köln
	-- 9: Man Kleider
	-- 10: Kohl Industries AG

--6.	Quais os vendedores que mais dão descontos nos Estados Unidos?
select * from (
select (select (select paisnome from pais where idpais = cli.idpais) 
		from cliente cli where idcliente= pd.idcliente), 
(select vendedornome from vendedor where idvendedor = pd.idvendedor), 
	sum(tabela1.desconto) desconto from pedido pd
inner join (
select idpedido, desconto from item
) as tabela1 ON pd.idpedido = tabela1.idpedido 
group by paisnome, vendedornome
) as resultado where paisnome = 'USA' order by desconto desc

-- Resultado 6 (Ranking):
	-- 1: Gael Monfils = 7415.1295
	-- 2: Yannick Sinner = 1160.054
	-- 3: Martina Hingis = 733.777
	-- 4: Cori Gauff =	404.55

--7.	Quais os fornecedores que dão a maior margem de lucro ($) 
--no segmento de “Vestuário Feminino” (Womens wear)?
select categorianome, 
(select fornecedornome from fornecedor where idfornecedor = table1.idfornecedor)
, sum(margemlucro) margemDeLucro from(
select (Select categorianome from categoria where idcategoria = pt.idcategoria), 
idfornecedor, idproduto from produto pt) as table1
INNER JOIN (select idproduto, ((vendas - (vendas - margembruta))/vendas) margemLucro from item) as table2
ON table1.idproduto = table2.idproduto
where categorianome = 'Womens wear'
group by categorianome, idfornecedor
order by margemdelucro desc

-- Resultado 7: 
-- Vendas Custo = Vendas - MargemBruta 
-- Margem de Lucro = (Vendas - (vendas - margemBruta))/Vendas

-- (RANKING)
-- 1: Global Outlet
-- 2: Baby Dress
-- 3: Pälsii Sports
-- 4: Luis Vilton
-- 5: Great Outdoors
-- 6: Wills Surfwear
-- 7: Netshoes
-- 8: Tennis Place
-- 9: USA Jeans
-- 10: L.A. Sports
-- 11: Surf Trip

--8.	Quanto que foi vendido ($) no ano de 2009? Analisando as 
--vendas anuais entre 2009 e 2012, podemos concluir que o faturamento 
--vem crescendo, se mantendo estável ou decaindo?
DO $$
DECLARE
	cursorTest NO SCROLL CURSOR (ano varchar) FOR select sum(table1.vendas) vendaTotal from pedido pd
inner join (
	select idpedido, sum(vendas) vendas 
	from item it group by idpedido order by idpedido
) as table1 on pd.idpedido = table1.idpedido where pd.data like ano;
	rec Record;
	periodo numeric = '2008';
BEGIN
	FOR i in 1..4
	LOOP
		periodo = periodo + 1;
		OPEN cursorTest(CONCAT('%',periodo));
		FETCH cursorTest into rec;
		RAISE NOTICE '%: %', periodo, rec.vendaTotal;
		CLOSE cursorTest;
	END LOOP;
END $$;

-- Resultado 8 (1): 87666.294
-- Resultado 8 (2): Crescendo

--9.	Quais são os principais clientes (vendas $) do segmento 
--“Calçados Masculinos” (Men´s Footwear) na Alemanha?

select * from (
select cli.clientenome, table1.categoriaNome, table1.vendas, 
(select paisnome from pais where idpais = cli.idpais) 
from cliente as cli
Inner join (
	select pd.idcliente, 
	(select (select categorianome from categoria where idcategoria = pd.idcategoria)
	 from produto as pd where idproduto = it.idproduto)
	, sum(vendas) vendas
	from item as it
	INNER JOIN pedido pd ON it.idpedido = pd.idpedido
	group by idcliente, categorianome order by idcliente
) as table1
	ON table1.idcliente = cli.idcliente
) as resultado 
where resultado.paisnome = 'Germany' 
and resultado.categorianome = 'Men´s Footwear'
order by vendas desc

-- Resultado 9 (RANKING):
	-- 1: GruneWald
	-- 2: Gluderstedt
	-- 3: Boombastic
	-- 4: Eintrach Gs
	-- 5: Warp AG
	-- 6: Noch Einmal GMBH
	-- 7: Casual Clothing
	-- 8: Halle Köln
	-- 9: Man Kleider
	-- 10: Kohl Industries AG

--10.	Quais os países nos quais mais se tiram pedidos (qtde total de pedidos)?	
select table1.paisnome, COUNT(pd.idpedido) qntPedidos from pedido pd
INNER JOIN (
	select idcliente, (select paisnome from pais where idpais = cli.idpais) 
	from cliente cli
) as table1 ON pd.idcliente = table1.idcliente 
group by paisnome
order by qntPedidos desc

-- Resultado 10 (RANKING):
-- 1: "Germany"
-- 2: USA
-- 3: "France"
-- 4: "Brazil"
-- 5: "UK"
-- 6: "Ireland"
-- 7: "Venezuela"
-- 8: "Mexico"
-- 9: "Canada"
-- 10: "Sweden"
-- 11: "Denmark"
-- 12: "Austria"
-- 13: "Spain"
-- 14: "Italy"
-- 15: "Argentina"
-- 16: "Portugal"
-- 17: "Belgium"
-- 18: "Finland"
-- 19: "Poland"
-- 20: "Switzerland"
-- 21: "Norway"
