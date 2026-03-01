drop table if exists comercializa ;
drop table if exists servida_por ;
drop table if exists serve ;
drop table if exists usa ;
drop table if exists Curso ;
drop table if exists Turma ;
drop table if exists Aluno ;
drop table if exists Utilizador ;
drop table if exists Disciplina ;
drop table if exists Formador ;
drop table if exists Empresa ;
drop table if exists CAE ;
drop table if exists Estabelecimento ;
drop table if exists Marca ;
drop table if exists Produto ;
drop table if exists Responsavel ;
drop table if exists AnoLetivo ;
drop table if exists DisponibilidadeEmpresa ;
drop table if exists Estagio ;
drop table if exists Zona ;
drop table if exists Transporte ;
drop table if exists AvaliacaoAnualEstab ;
drop table if exists Administrativo ;
 
create table comercializa
(
   Estabelecimento_Empresa_Empresa_ID_   integer   not null,
   Estabelecimento_Estabelecimento_ID_   integer   not null,
   Produto_Produto_ID_   integer   not null,
 
   constraint PK_comercializa primary key (Estabelecimento_Empresa_Empresa_ID_, Estabelecimento_Estabelecimento_ID_, Produto_Produto_ID_)
);
 
create table servida_por
(
   Zona_Zona_ID_   integer   not null,
   Transporte_Transporte_ID_   integer   not null,
 
   constraint PK_servida_por primary key (Zona_Zona_ID_, Transporte_Transporte_ID_)
);
 
create table serve
(
   Estabelecimento_Empresa_Empresa_ID_   integer   not null,
   Estabelecimento_Estabelecimento_ID_   integer   not null,
   Transporte_Transporte_ID_   integer   not null,
 
   constraint PK_serve primary key (Estabelecimento_Empresa_Empresa_ID_, Estabelecimento_Estabelecimento_ID_, Transporte_Transporte_ID_)
);
 
create table usa
(
   Estabelecimento_Empresa_Empresa_ID_   integer   not null,
   Estabelecimento_Estabelecimento_ID_   integer   not null,
   Transporte_Transporte_ID_   integer   not null,
 
   constraint PK_usa primary key (Estabelecimento_Empresa_Empresa_ID_, Estabelecimento_Estabelecimento_ID_, Transporte_Transporte_ID_)
);
 
create table Curso
(
   Curso_ID   integer   not null,
   curso_id   Integer   null,
   codigo   text   null,
   designacao   text   null,
 
   constraint PK_Curso primary key (Curso_ID)
);
 
create table Turma
(
   Curso_Curso_ID   integer   not null,
   AnoLetivo_AnoLetivo_ID   integer   not null,
   Turma_ID   integer   not null,
   turma_id   Integer   null,
   sigla   text   null,
   ano   Integer   null,
 
   constraint PK_Turma primary key (Turma_ID)
);
 
create table Aluno
(
   Utilizador_Utilizador_ID   integer   not null,
   Utilizador_Utilizador_ID   integer   not null,
   Administrativo_Utilizador_Utilizador_ID   integer   not null,
   aluno_id   Integer   null,
   numero   Integer   null,
   registadoEm   Date   null,
 
   constraint PK_Aluno primary key (Utilizador_Utilizador_ID)
);
 
create table Utilizador
(
   Utilizador_ID   integer   not null,
   user_id   Integer   null,
   login   text   null,
   password_hash   text   null,
   nome   text   null,
   tipo   integer   null,
 
   constraint PK_Utilizador primary key (Utilizador_ID)
);
 
create table Disciplina
(
   Formador_Utilizador_Utilizador_ID   integer   not null,
   Disciplina_ID   integer   not null,
   disciplina_id   Integer   null,
   nome   text   null,
 
   constraint PK_Disciplina primary key (Disciplina_ID)
);
 
create table Formador
(
   Utilizador_Utilizador_ID   integer   not null,
   Utilizador_Utilizador_ID   integer   not null,
   Disciplina_Disciplina_ID   integer   not null,
   Disciplina_Disciplina_ID   integer   not null,
   formador_id   Integer   null,
   numero   Integer   null,
   disciplina   text   null,
 
   constraint PK_Formador primary key (Utilizador_Utilizador_ID)
);
 
create table Empresa
(
   CAE_CAE_ID   integer   null,
   Administrativo_Utilizador_Utilizador_ID   integer   not null,
   Empresa_ID   integer   not null,
   empresa_id   Integer   null,
   firma   text   null,
   nif   text   null,
   sede_morada   text   null,
   localidade   text   null,
   cod_postal   text   null,
   telefone   text   null,
   email   text   null,
   website   text   null,
 
   constraint PK_Empresa primary key (Empresa_ID)
);
 
create table CAE
(
   Administrativo_Utilizador_Utilizador_ID   integer   not null,
   CAE_ID   integer   not null,
   cae_id   Integer   null,
   codigo   text   null,
   descricao   text   null,
 
   constraint PK_CAE primary key (CAE_ID)
);
 
create table Estabelecimento
(
   Empresa_Empresa_ID   integer   not null,
   Administrativo_Utilizador_Utilizador_ID   integer   not null,
   Estabelecimento_ID   integer   not null,
   estab_id   Integer   null,
   nome_comercial   text   null,
   morada   text   null,
   localidade   text   null,
   cod_postal   text   null,
   telefone   text   null,
   email   text   null,
   foto   text   null,
   horario   text   null,
   data_fundacao   Date   null,
   obs   text   null,
   aceitou_estagiarios   Boolean   null,
 
   constraint PK_Estabelecimento primary key (Empresa_Empresa_ID, Estabelecimento_ID)
);
 
create table Marca
(
   Marca_ID   integer   not null,
   marca_id   Integer   null,
   nome   text   null,
 
   constraint PK_Marca primary key (Marca_ID)
);
 
create table Produto
(
   Marca_Marca_ID   integer   not null,
   Marca_Marca_ID   integer   not null,
   Produto_ID   integer   not null,
   produto_id   Integer   null,
   nome   text   null,
   marca   text   null,
   principal   bit   null,
 
   constraint PK_Produto primary key (Produto_ID)
);
 
create table Responsavel
(
   Estabelecimento_Empresa_Empresa_ID   integer   not null,
   Estabelecimento_Estabelecimento_ID   integer   not null,
   Responsavel_ID   integer   not null,
   resp_id   Integer   null,
   nome   text   null,
   titulo   text   null,
   cargo   text   null,
   tel_direto   text   null,
   telemovel   text   null,
   email   text   null,
 
   constraint PK_Responsavel primary key (Responsavel_ID)
);
 
create table AnoLetivo
(
   AnoLetivo_ID   integer   not null,
   ano_id   Integer   null,
   etiqueta   text   null,
   data_inicio   Date   null,
   data_fim   Date   null,
 
   constraint PK_AnoLetivo primary key (AnoLetivo_ID)
);
 
create table DisponibilidadeEmpresa
(
   Empresa_Empresa_ID   integer   not null,
   AnoLetivo_AnoLetivo_ID   integer   not null,
   DisponibilidadeEmpresa_ID   integer   not null,
   disponibilidade_id   Integer   null,
   disponivel   Boolean   null,
   capacidade   Integer   null,
 
   constraint PK_DisponibilidadeEmpresa primary key (Empresa_Empresa_ID, DisponibilidadeEmpresa_ID)
);
 
create table Estagio
(
   Aluno_Utilizador_Utilizador_ID   integer   not null,
   Formador_Utilizador_Utilizador_ID   integer   not null,
   Responsavel_Responsavel_ID   integer   not null,
   Estagio_ID   integer   not null,
   estagio_id   Integer   null,
   dt_inicio   Date   null,
   dt_fim   Date   null,
   nota_empresa   Integer   null,
   nota_escola   Integer   null,
   nota_procura   Integer   null,
   nota_relatorio   Integer   null,
   nota_final   Real   null,
   classificacao_local   Integer   null,
 
   constraint PK_Estagio primary key (Estagio_ID)
);
 
create table Zona
(
   Zona_ID   integer   not null,
   zona_id   Integer   null,
   designacao   text   null,
   localidade   text   null,
   mapa   text   null,
 
   constraint PK_Zona primary key (Zona_ID)
);
 
create table Transporte
(
   Transporte_ID   integer   not null,
   transp_id   Integer   null,
   meio   text   null,
   linha   text   null,
 
   constraint PK_Transporte primary key (Transporte_ID)
);
 
create table AvaliacaoAnualEstab
(
   Estabelecimento_Empresa_Empresa_ID   integer   not null,
   Estabelecimento_Estabelecimento_ID   integer   not null,
   AnoLetivo_AnoLetivo_ID   integer   not null,
   AvaliacaoAnualEstab_ID   integer   not null,
   avaliacao_id   Integer   null,
   media   Real   null,
   n_ratings   Integer   null,
 
   constraint PK_AvaliacaoAnualEstab primary key (AvaliacaoAnualEstab_ID)
);
 
create table Administrativo
(
   Utilizador_Utilizador_ID   integer   not null,
   admin_id   Integer   null,
 
   constraint PK_Administrativo primary key (Utilizador_Utilizador_ID)
);
 
alter table comercializa
   add constraint FK_Estabelecimento_comercializa_Produto_ foreign key (Estabelecimento_Empresa_Empresa_ID_, Estabelecimento_Estabelecimento_ID_)
   references Estabelecimento(Empresa_Empresa_ID, Estabelecimento_ID)
   on delete cascade
   on update cascade
; 
alter table comercializa
   add constraint FK_Produto_comercializa_Estabelecimento_ foreign key (Produto_Produto_ID_)
   references Produto(Produto_ID)
   on delete cascade
   on update cascade
;
 
alter table servida_por
   add constraint FK_Zona_servida_por_Transporte_ foreign key (Zona_Zona_ID_)
   references Zona(Zona_ID)
   on delete cascade
   on update cascade
; 
alter table servida_por
   add constraint FK_Transporte_servida_por_Zona_ foreign key (Transporte_Transporte_ID_)
   references Transporte(Transporte_ID)
   on delete cascade
   on update cascade
;
 
alter table serve
   add constraint FK_Estabelecimento_serve_Transporte_ foreign key (Estabelecimento_Empresa_Empresa_ID_, Estabelecimento_Estabelecimento_ID_)
   references Estabelecimento(Empresa_Empresa_ID, Estabelecimento_ID)
   on delete cascade
   on update cascade
; 
alter table serve
   add constraint FK_Transporte_serve_Estabelecimento_ foreign key (Transporte_Transporte_ID_)
   references Transporte(Transporte_ID)
   on delete cascade
   on update cascade
;
 
alter table usa
   add constraint FK_Estabelecimento_usa_Transporte_ foreign key (Estabelecimento_Empresa_Empresa_ID_, Estabelecimento_Estabelecimento_ID_)
   references Estabelecimento(Empresa_Empresa_ID, Estabelecimento_ID)
   on delete cascade
   on update cascade
; 
alter table usa
   add constraint FK_Transporte_usa_Estabelecimento_ foreign key (Transporte_Transporte_ID_)
   references Transporte(Transporte_ID)
   on delete cascade
   on update cascade
;
 
 
alter table Turma
   add constraint FK_Turma_tem_Curso foreign key (Curso_Curso_ID)
   references Curso(Curso_ID)
   on delete restrict
   on update cascade
; 
alter table Turma
   add constraint FK_Turma_noname_AnoLetivo foreign key (AnoLetivo_AnoLetivo_ID)
   references AnoLetivo(AnoLetivo_ID)
   on delete restrict
   on update cascade
;
 
alter table Aluno
   add constraint FK_Aluno_e_Utilizador foreign key (Utilizador_Utilizador_ID)
   references Utilizador(Utilizador_ID)
   on delete restrict
   on update cascade
; 
alter table Aluno
   add constraint FK_Aluno_Utilizador foreign key (Utilizador_Utilizador_ID)
   references Utilizador(Utilizador_ID)
   on delete cascade
   on update cascade
; 
alter table Aluno
   add constraint FK_Aluno_regista_Administrativo foreign key (Administrativo_Utilizador_Utilizador_ID)
   references Administrativo(Utilizador_Utilizador_ID)
   on delete restrict
   on update cascade
;
 
 
alter table Disciplina
   add constraint FK_Disciplina_leciona_Formador foreign key (Formador_Utilizador_Utilizador_ID)
   references Formador(Utilizador_Utilizador_ID)
   on delete restrict
   on update cascade
;
 
alter table Formador
   add constraint FK_Formador_e_Utilizador foreign key (Utilizador_Utilizador_ID)
   references Utilizador(Utilizador_ID)
   on delete restrict
   on update cascade
; 
alter table Formador
   add constraint FK_Formador_Utilizador foreign key (Utilizador_Utilizador_ID)
   references Utilizador(Utilizador_ID)
   on delete cascade
   on update cascade
; 
alter table Formador
   add constraint FK_Formador_leciona_Disciplina foreign key (Disciplina_Disciplina_ID, Disciplina_Disciplina_ID)
   references Disciplina(Disciplina_ID, Disciplina_ID)
   on delete restrict
   on update cascade
;
 
alter table Empresa
   add constraint FK_Empresa_participa_CAE foreign key (CAE_CAE_ID)
   references CAE(CAE_ID)
   on delete set null
   on update cascade
; 
alter table Empresa
   add constraint FK_Empresa_regista_Administrativo foreign key (Administrativo_Utilizador_Utilizador_ID)
   references Administrativo(Utilizador_Utilizador_ID)
   on delete restrict
   on update cascade
;
 
alter table CAE
   add constraint FK_CAE_regista_Administrativo foreign key (Administrativo_Utilizador_Utilizador_ID)
   references Administrativo(Utilizador_Utilizador_ID)
   on delete restrict
   on update cascade
;
 
alter table Estabelecimento
   add constraint FK_Estabelecimento_possui_Empresa foreign key (Empresa_Empresa_ID)
   references Empresa(Empresa_ID)
   on delete cascade
   on update cascade
; 
alter table Estabelecimento
   add constraint FK_Estabelecimento_regista_Administrativo foreign key (Administrativo_Utilizador_Utilizador_ID)
   references Administrativo(Utilizador_Utilizador_ID)
   on delete restrict
   on update cascade
;
 
 
alter table Produto
   add constraint FK_Produto_da_marca_Marca foreign key (Marca_Marca_ID)
   references Marca(Marca_ID)
   on delete restrict
   on update cascade
; 
alter table Produto
   add constraint FK_Produto_noname_Marca foreign key (Marca_Marca_ID)
   references Marca(Marca_ID)
   on delete restrict
   on update cascade
;
 
alter table Responsavel
   add constraint FK_Responsavel_tem_Estabelecimento foreign key (Estabelecimento_Empresa_Empresa_ID, Estabelecimento_Estabelecimento_ID)
   references Estabelecimento(Empresa_Empresa_ID, Estabelecimento_ID)
   on delete restrict
   on update cascade
;
 
 
alter table DisponibilidadeEmpresa
   add constraint FK_DisponibilidadeEmpresa_define_disponibilidade_Empresa foreign key (Empresa_Empresa_ID)
   references Empresa(Empresa_ID)
   on delete cascade
   on update cascade
; 
alter table DisponibilidadeEmpresa
   add constraint FK_DisponibilidadeEmpresa_para_ano_AnoLetivo foreign key (AnoLetivo_AnoLetivo_ID)
   references AnoLetivo(AnoLetivo_ID)
   on delete restrict
   on update cascade
;
 
alter table Estagio
   add constraint FK_Estagio_realiza_Aluno foreign key (Aluno_Utilizador_Utilizador_ID)
   references Aluno(Utilizador_Utilizador_ID)
   on delete restrict
   on update cascade
; 
alter table Estagio
   add constraint FK_Estagio_acompanha_Formador foreign key (Formador_Utilizador_Utilizador_ID)
   references Formador(Utilizador_Utilizador_ID)
   on delete restrict
   on update cascade
; 
alter table Estagio
   add constraint FK_Estagio_supervisiona_Responsavel foreign key (Responsavel_Responsavel_ID)
   references Responsavel(Responsavel_ID)
   on delete restrict
   on update cascade
;
 
 
 
alter table AvaliacaoAnualEstab
   add constraint FK_AvaliacaoAnualEstab_tem_avaliacoes_Estabelecimento foreign key (Estabelecimento_Empresa_Empresa_ID, Estabelecimento_Estabelecimento_ID)
   references Estabelecimento(Empresa_Empresa_ID, Estabelecimento_ID)
   on delete restrict
   on update cascade
; 
alter table AvaliacaoAnualEstab
   add constraint FK_AvaliacaoAnualEstab_de_ano_AnoLetivo foreign key (AnoLetivo_AnoLetivo_ID)
   references AnoLetivo(AnoLetivo_ID)
   on delete restrict
   on update cascade
;
 
alter table Administrativo
   add constraint FK_Administrativo_Utilizador foreign key (Utilizador_Utilizador_ID)
   references Utilizador(Utilizador_ID)
   on delete cascade
   on update cascade
;
 
