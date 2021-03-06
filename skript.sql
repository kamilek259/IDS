drop TABLE Autor CASCADE CONSTRAINTS;
drop TABLE Zanr CASCADE CONSTRAINTS;
drop TABLE Dilo CASCADE CONSTRAINTS;
drop TABLE Casopis CASCADE CONSTRAINTS;
drop TABLE Kniha CASCADE CONSTRAINTS;
drop TABLE Napsal CASCADE CONSTRAINTS;
drop TABLE Uzivatel CASCADE CONSTRAINTS;
drop TABLE Ctenar CASCADE CONSTRAINTS;
drop TABLE Pracovnik CASCADE CONSTRAINTS;
drop TABLE Rezervace CASCADE CONSTRAINTS;
drop TABLE Rezervovana CASCADE CONSTRAINTS;
drop TABLE Vypujcka CASCADE CONSTRAINTS;
drop TABLE Vypujcena CASCADE CONSTRAINTS;
drop sequence autor_seq;
drop sequence zanr_seq;
drop sequence dilo_seq;
drop sequence dilo_ck_seq;
drop sequence uzivatel_seq;
drop sequence uzivatel_cp_seq;
drop sequence rezervace_seq;
drop sequence vypujcka_seq;


--auto increment IDcek
create sequence autor_seq start with 1;
create sequence zanr_seq start with 1;
create sequence dilo_seq start with 1;
create sequence dilo_ck_seq start with 1; --pro casopisy a knihy
create sequence uzivatel_seq start with 1;
create sequence uzivatel_cp_seq start with 1; --pro ctenare a pracovniky
create sequence rezervace_seq start with 1;
create sequence vypujcka_seq start with 1;


--vytvoreni tabulky Autor
create TABLE Autor (
    id_autor number(10) default autor_seq.nextval NOT NULL,
    jmeno VARCHAR(30),
    prijmeni VARCHAR(50),
    vydavatel varchar(150),
    datum_narozeni DATE,
    datum_umrti DATE,
    narodnost VARCHAR(30),
    
    CONSTRAINT PK_autor PRIMARY KEY (id_autor)
);

--vytvoreni tabulky Zanr
create TABLE Zanr (
    id_zanr number(10) default zanr_seq.nextval NOT NULL,
    nazev_zanr VARCHAR(30),
    
    CONSTRAINT PK_zanr PRIMARY KEY (id_zanr)
);

--vytvoreni tabulky Dilo
create table Dilo (
  id_dilo number(10) default dilo_seq.nextval NOT NULL,
  nazev_dila VARCHAR(50),
  rok_vydani NUMBER(4),
  pocet_stran NUMBER(6),
  jazyk VARCHAR(30),
  id_zanr INTEGER NOT NULL,
  
    CONSTRAINT FK_zanr_dilo FOREIGN KEY (id_zanr) REFERENCES Zanr,
    CONSTRAINT PK_dilo PRIMARY KEY (id_dilo)
);

--vytvoreni tabulky Casopis
create table Casopis (
    id_dilo number(10) default dilo_ck_seq.nextval NOT NULL,
    ISSN number(8),
    rocnik NUMBER(4),
    cislo NUMBER(3),
    
    CONSTRAINT ISSN_format CHECK (REGEXP_LIKE(ISSN,'[0-9]{8}','i')),
    CONSTRAINT FK_id_dilo_casopis FOREIGN KEY (id_dilo) REFERENCES Dilo,
    CONSTRAINT PK_casopis PRIMARY KEY (id_dilo, ISSN)
);

--vytvoreni tabulky Kniha
create table Kniha (
    id_dilo number(10) default dilo_ck_seq.nextval NOT NULL,
    ISBN VARCHAR(13),
    
    CONSTRAINT ISBN_format CHECK (REGEXP_LIKE(ISBN,'[0-9]{13}','i')),
    CONSTRAINT FK_id_dilo_kniha FOREIGN KEY (id_dilo) REFERENCES Dilo,
    CONSTRAINT PK_kniha PRIMARY KEY (id_dilo, ISBN)
);
   
--vytvoreni tabulky Napsal
create table Napsal (
    id_autor INTEGER NOT NULL,
    id_dilo INTEGER NOT NULL,
    
    CONSTRAINT FK_id_autor_napsal FOREIGN KEY (id_autor) REFERENCES Autor,
    CONSTRAINT FK_id_dilo_napsal FOREIGN KEY (id_dilo) REFERENCES Dilo,
    CONSTRAINT PK_napsal PRIMARY KEY (id_autor, id_dilo)
);

--vytvoreni tabuly Uzivatel
create table Uzivatel (
    id_uzivatel number(10) default uzivatel_seq.nextval NOT NULL,
    jmeno VARCHAR(30),
    prijmeni VARCHAR(50),
    ulice VARCHAR(30),
    mesto VARCHAR(30),
    cislo_popisne VARCHAR(10),
    psc NUMBER(5),
    telefon1 varchar(13),
    telefon2 varchar(10),
    telefon3 varchar(10),
    email varchar(100),
    
    CONSTRAINT PK_uzivatel PRIMARY KEY (id_uzivatel)
);
 
--vytvoreni tabulky Ctenar
create table Ctenar (
    id_uzivatel number(10) default uzivatel_cp_seq.nextval NOT NULL,
    aktivni char(1), --boolean neni v oracle, takze nahrada bude Y-true, N-false
    
    CONSTRAINT FK_id_uzivatel_ctenar FOREIGN KEY (id_uzivatel) REFERENCES Uzivatel,
    CONSTRAINT PK_ctenar PRIMARY KEY (id_uzivatel)
);

--vytvoreni tabulky Pracovnik
create table Pracovnik (
   id_uzivatel number(10) default uzivatel_cp_seq.nextval NOT NULL,
   cislo_uctu VARCHAR(16),

    CONSTRAINT FK_id_uzivatel_pracovnik FOREIGN KEY (id_uzivatel) REFERENCES Uzivatel,
    CONSTRAINT PK_pracovnik PRIMARY KEY (id_uzivatel)
);

--vytvoreni tabulky Rezervace
create table Rezervace (
    cislo_rezervace number(10) default rezervace_seq.nextval NOT NULL,
    datum_rezervace DATE,
    platnost char(1), --boolean neni v oracle, takze nahrada bude Y-true, N-false
    id_uzivatel INTEGER NOT NULL,

    
    CONSTRAINT FK_uzivatel_rezervace FOREIGN KEY (id_uzivatel) REFERENCES Uzivatel,
    CONSTRAINT PK_rezervace PRIMARY KEY (cislo_rezervace)
);

--vytvoreni tabulky Rezervovana
create table Rezervovana (
    cislo_rezervace INTEGER NOT NULL,
    id_dilo INTEGER NOT NULL,
    
    CONSTRAINT FK_cislo_rezervace_rezervovana FOREIGN KEY (cislo_rezervace) REFERENCES Rezervace,
    CONSTRAINT FK_id_dilo_rezervovana FOREIGN KEY (id_dilo) REFERENCES Dilo,
    CONSTRAINT PK_rezervovana PRIMARY KEY (cislo_rezervace, id_dilo)
);

--vytvoreni tabulky Vypujcka
create table Vypujcka (
    cislo_vypujcka number(10) default vypujcka_seq.nextval NOT NULL,
    datum_vypujcka DATE NOT NULL,
    datum_navrat DATE,
    id_uzivatel INTEGER NOT NULL,
    
    CONSTRAINT FK_id_uzivatel_vypujcka FOREIGN KEY (id_uzivatel) REFERENCES Uzivatel,
    CONSTRAINT PK_vypujcka PRIMARY KEY (cislo_vypujcka)
);

--vytvoreni tabulky Vypujcena
create table Vypujcena (
    cislo_vypujcka INTEGER NOT NULL,
    id_dilo INTEGER NOT NULL,
    
    CONSTRAINT FK_cislo_vypujcka_vypujcena FOREIGN KEY (cislo_vypujcka) REFERENCES Vypujcka,
    CONSTRAINT FK_id_dilo_vypujcena FOREIGN KEY (id_dilo) REFERENCES Dilo,
    CONSTRAINT PK_vypujcena PRIMARY KEY (cislo_vypujcka, id_dilo)
);
--vlozeni do tabulky zanr
insert into Zanr (nazev_zanr) values('Roman');
insert into Zanr (nazev_zanr) values('Pohadka');
insert into Zanr (nazev_zanr) values('Fantazy');
insert into Zanr (nazev_zanr) values('Horor');
insert into Zanr (nazev_zanr) values('Detektivni');
insert into Zanr (nazev_zanr) values('Vedecky');

--vlozeni do tabulky autor
insert into Autor (jmeno, prijmeni, datum_narozeni, datum_umrti, narodnost) values('Jules', 'Verne',date '1828-02-08',date '1905-03-24', 'Francie');
insert into Autor (jmeno, prijmeni, datum_narozeni, datum_umrti, narodnost) values('Jacob', 'Grimm',date '1785-01-04',date '1863-09-20', 'Nemecko');
insert into Autor (jmeno, prijmeni, datum_narozeni, datum_umrti, narodnost) values('Wilhelm', 'Grimm',date '1786-02-24',date '1859-12-16', 'Nemecko');
insert into Autor (jmeno, prijmeni, datum_narozeni, narodnost) values('Stephen', 'King',date '1947-09-21', 'USA');
insert into Autor (jmeno, prijmeni, datum_narozeni, narodnost) values('Jo', 'Nesbo',date '1960-03-29', 'Norsko');
insert into Autor (vydavatel, narodnost) values('Czech News Center', 'Ceska Republika');

--vlozeni do tabulky dilo, casopis, kniha
insert into Dilo (nazev_dila, rok_vydani, pocet_stran, jazyk, id_zanr) values('Jen??cek a Marenka', '1812', '40', 'Cesky', '2');
insert into Kniha (ISBN) values ('1548658978785');
insert into Dilo (nazev_dila, rok_vydani, pocet_stran, jazyk, id_zanr) values('To', '1986', '1096', 'Anglicky', '4');
insert into Kniha (ISBN) values ('8121681651295');
insert into Dilo (nazev_dila, rok_vydani, pocet_stran, jazyk, id_zanr) values('ABC', '1957', '68', 'Cesky', '6');
insert into Casopis (ISSN, Rocnik, Cislo) values ('15987516', '2021', '05');
insert into Dilo (nazev_dila, rok_vydani, pocet_stran, jazyk, id_zanr) values('Snehul??k', '2007', '520', 'Cesky', '5');
insert into Kniha (ISBN) values ('7121353189884');


--vlozeni do tabulky napsal
insert into Napsal values('2',  '1');
insert into Napsal values('3',  '1');
insert into Napsal values('4',  '2');
insert into Napsal values('5',  '3');
insert into Napsal values('6',  '4');

--vlozeni do tabulky uzivatel, ctenar, pracovnik
insert into Uzivatel (jmeno, prijmeni, ulice, mesto, cislo_popisne, psc, telefon1, email) values('Viktor', 'Nov??k', 'Z??hrebsk??', 'Olomouc', '25', '77900', '789654321', 'vnovak@seznam.cz');
insert into Pracovnik (cislo_uctu) values ('026849842/0300');
insert into Uzivatel (jmeno, prijmeni, ulice, mesto, cislo_popisne, psc, telefon1, email) values('Tom????', 'Krejc??', 'Mozolky', 'Brno', '37', '60100', '798465132', 'tkrej02@seznam.cz');
insert into Ctenar (aktivni) values ('Y');
insert into Uzivatel (jmeno, prijmeni, ulice, mesto, cislo_popisne, psc, telefon1, email) values('Stanislav', 'Skopc??k', 'N??mest?? Svobody', 'Brno', '2/2B', '66000', '666666658', 'pusinka555@seznam.cz');
insert into Ctenar (aktivni) values ('Y');
insert into Uzivatel (jmeno, prijmeni, ulice, mesto, cislo_popisne, psc, telefon1, email) values('Alice', 'Plach??', 'Orlojsk??', 'Praha', '755/7C', '12500', '658658658', 'vrtule25@gmail.com');
insert into Ctenar (aktivni) values ('Y');


--vlozeni do tabulky rezervace
insert into Rezervace (datum_rezervace, platnost, id_uzivatel) values(date '2022-03-10', 'N', '3');
insert into Rezervace (datum_rezervace, platnost, id_uzivatel) values(date '2022-03-26', 'N', '1');
insert into Rezervace (datum_rezervace, platnost, id_uzivatel) values(date '2022-03-27', 'Y', '4');
insert into Rezervace (datum_rezervace, platnost, id_uzivatel) values(date '2022-03-28', 'Y', '2');
insert into Rezervace (datum_rezervace, platnost, id_uzivatel) values(date '2022-03-30', 'Y', '2');

--vlozeni do tabulky rezervovana
insert into Rezervovana values('1', '1');
insert into Rezervovana values('2', '3');
insert into Rezervovana values('3', '3');
insert into Rezervovana values('4', '2');
insert into Rezervovana values('4', '4');


--vlozeni do tabulky vypujcka, vypujcena
insert into Vypujcka (datum_vypujcka, datum_navrat, id_uzivatel) values(date '2022-03-11', date '2022-03-15', '3');
insert into Vypujcena values('1', '1');
insert into Vypujcka (datum_vypujcka, id_uzivatel) values(date '2022-03-27', '1');
insert into Vypujcena values('2', '3');


