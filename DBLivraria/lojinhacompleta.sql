/**
	Projeto Papelaria
    @author Jefferson Cruz
    Ver
*/
create database papelariajefferson;
use papelariajefferson;
create table usuarios (
	idusu int primary key auto_increment,
    usuario varchar(40) not null,
    login varchar(15) not null unique,
    senha varchar(255) not null,
    perfil varchar(10) not null
);
insert into usuarios (usuario,login,senha,perfil)
values ('administrador','admin',md5('admin'),'admin');

insert into usuarios (usuario,login,senha,perfil)
values ('Jefferson','jeff',md5('123456'),'vendedor');

create table fornecedores (
	idfor int primary key auto_increment,
    cnpj varchar(20) not null unique,
    ie varchar(20) unique,
    im varchar(20) unique,
    razao varchar(50) not null,
    fantasia varchar(60) not null,
    site varchar(100),
    fone varchar(20) not null,
    contato varchar(20),     
	email varchar(150),
    cep varchar(10) not null,
    endereco varchar(255) not null,
    numero varchar(10) not null,
    complemento varchar(100),
    bairro varchar(100) not null,
    cidade varchar(50) not null,
    uf char(2) not null,
    obs varchar(255)
);
insert into fornecedores
(cnpj,razao,fantasia,fone,cep,endereco,numero,bairro,cidade,uf)
values ('51115115000162','Editora Isabela','Editora Isabela','1738187542','14783140','Avenida Cristiano de Carvalho','302','Diva','Barretos','SP');

insert into fornecedores
(cnpj,razao,fantasia,fone,cep,endereco,numero,bairro,cidade,uf)
values ('06618188000112','Editora Tãnia','Editora Tãnia','1127630612','02378260','Rua Bom Jesus','146','Jardim Denise','São Paulo','SP');

insert into fornecedores
(cnpj,razao,fantasia,fone,cep,endereco,numero,bairro,cidade,uf)
values ('54750866000149','Editora Valentina','Editora Valentina','1726672398','15040709','Avenida Doutor Ernani Pires Domingues','711','Residencial Palestra','São José do Rio Preto','SP');

select * from fornecedores;
drop table produtos;
create table produtos(
	codigo int primary key auto_increment,
    barcode varchar(20) unique,
    produto varchar(100) not null,
    descricao varchar(100) not null,
    fabricante varchar(100) not null,
    datacad timestamp default current_timestamp,
    dataval date,
    estoque int not null,
    estoquemin int not null,
    unidade varchar(10) not null,
    localizacao varchar(50),
    custo decimal(10,2) not null,
    lucro decimal(10,2),
    idfor int not null,
    foreign key(idfor) references fornecedores(idfor)
);
describe produtos;

insert into produtos (barcode,produto,descricao,fabricante,estoque,estoquemin,unidade,localizacao,custo,lucro,idfor)
values ('5687544567','TUDO É RIO','Tudo é rio é o livro de estreia de Carla Madeira. Com uma narrativa madura','Livraria Cultura',25,30,'UN','Setor Livros',54.90,10,1);

insert into produtos (barcode,produto,descricao,fabricante,estoque,estoquemin,unidade,localizacao,custo,lucro,idfor)
values ('5554443322','PERDAS E GANHOS','Lya Luft é uma mulher de seu tempo, e sobre ele dá seu testemunho em tudo o que escreve','Livraria Cultura',20,30,'UN','Setor Livros',59.90,10,1);

insert into produtos (barcode,produto,descricao,fabricante,estoque,estoquemin,unidade,localizacao,custo,lucro,idfor)
values ('4434551885','O Império De Ouro - Vol 3','O capítulo final da aclamada Trilogia de Daevabad','Livraria Curitiba',100,20,'UN','Setor Livros',81.90,10,3);

insert into produtos (barcode,produto,descricao,fabricante,estoque,estoquemin,unidade,localizacao,custo,lucro,idfor)
values ('6546522235','Luzes Do Norte','Luzes do Norte é o livro de estreia de Giulianna Domingues','Livraria Curitiba',200,20,'UN','Setor Livros',40.90,10,3);

insert into produtos (barcode,produto,descricao,fabricante,estoque,estoquemin,unidade,localizacao,custo,lucro,idfor)
values ('9588421223','Você É Aquilo Que Pensa','Era nisso que James Allen acreditava quando escreveu este livro','Livraria Curitiba',300,50,'UN','Setor Livros',29.70,10,2);

select codigo as código,produto,
estoque, estoquemin as estoque_mínimo
from produtos where estoque < estoquemin;

create table clientes (
	idcli int primary key auto_increment,
    nome varchar(40) not null,
    fone varchar(20) not null,
    cpf varchar(20) unique,
    email varchar(100),
    marketing char(1) not null,
    cep varchar(10),
    endereco varchar(255),
    numero varchar(20),
    complemento varchar(100),
    bairro varchar(100),
    cidade varchar(50),
    uf char(2)
);

insert into clientes(nome,fone,marketing)
values('Vitor Renan Peixoto','997509986','n');

insert into clientes(nome,fone,marketing)
values('Samuel Matheus da Cunha','994983809','s');

select * from produtos;

select * from clientes where marketing='s';

create table pedidos (
	pedido int primary key auto_increment,
    dataped timestamp default current_timestamp,
    total decimal(10,2),
    idcli int not null,
    foreign key(idcli) references clientes(idcli)
);

insert into pedidos(idcli) values(1);

insert into pedidos(idcli) values(2);

select * from pedidos inner join clientes on pedidos.idcli = clientes.idcli;

select
pedidos.pedido,
date_format(pedidos.dataped,'%d/%m/%Y - %H:%i') as data_ped,
clientes.nome as cliente,
clientes.fone
from pedidos inner join clientes
on pedidos.idcli = clientes.idcli;

create table carrinho (
	pedido int not null,
    codigo int not null,
    quantidade int not null,
    foreign key(pedido) references pedidos(pedido),
	foreign key(codigo) references produtos(codigo)
);
select * from produtos;

insert into carrinho values (1,5,5);
insert into carrinho values (2,1,3);

select * from carrinho;

select pedidos.pedido,
carrinho.codigo as código,
produtos.produto,
carrinho.quantidade,
custo + (custo * lucro)/100 as venda 
from (carrinho inner join pedidos on carrinho.pedido =
pedidos.pedido)
inner join produtos on carrinho.codigo = produtos.codigo;

update carrinho
inner join produtos
on carrinho.codigo = produtos.codigo
set produtos.estoque = produtos.estoque - carrinho.quantidade
where carrinho.quantidade > 0;
