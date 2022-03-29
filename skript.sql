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

--vytvoreni tabulky Autor
create TABLE Autor (
    id_autor INTEGER NOT NULL,
    jmeno VARCHAR(30),
    prijmeni VARCHAR(50),
    datum_narozeni DATE,
    datum_umrti DATE,
    narodnost VARCHAR(30),
    
    CONSTRAINT PK_autor PRIMARY KEY (id_autor)
);

--vytvoreni tabulky Zanr
create TABLE Zanr (
    id_zanr INTEGER NOT NULL,
    nazev_zanru VARCHAR(30),
    
    CONSTRAINT PK_zanr PRIMARY KEY (id_zanr)
);

--vytvoreni tabulky Dilo
create table Dilo (
  id_dilo INTEGER NOT NULL,
  nazev_dila VARCHAR(50),
  datum_vydani DATE,
  pocet_stran NUMBER(6),
  jazyk VARCHAR(30),
  id_zanr INTEGER NOT NULL,
  
    CONSTRAINT FK_zanr_dilo FOREIGN KEY (id_zanr) REFERENCES Zanr,
    CONSTRAINT PK_dilo PRIMARY KEY (id_dilo)
);

--vytvoreni tabulky Casopis
create table Casopis (
    id_dilo INTEGER NOT NULL,
    ISSN VARCHAR(9) NOT NULL,
    rocnik NUMBER(4),
    cislo NUMBER(3),
    
    --osetreni ISSN TODO
    CONSTRAINT FK_id_dilo_casopis FOREIGN KEY (id_dilo) REFERENCES Dilo,
    CONSTRAINT PK_casopis PRIMARY KEY (id_dilo, ISSN)
);

--vytvoreni tabulky Kniha
create table Kniha (
    id_dilo INTEGER NOT NULL,
    ISBN VARCHAR(13) NOT NULL,
    
    --osetreni ISSN TODO
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
    id_uzivatel INTEGER NOT NULL,
    jmeno VARCHAR(30),
    prijmeni VARCHAR(50),
    ulice VARCHAR(30),
    mesto VARCHAR(30),
    cislo_popisne VARCHAR(10),
    psc NUMBER(5),
    telefon varchar(10),
    email varchar(100),
    
    CONSTRAINT PK_uzivatel PRIMARY KEY (id_uzivatel)
);
 
--vytvoreni tabulky Ctenar
create table Ctenar (
    id_uzivatel INTEGER NOT NULL,

    CONSTRAINT FK_uzivatel_ctenar FOREIGN KEY (id_uzivatel) REFERENCES Uzivatel,
    CONSTRAINT PK_ctenar PRIMARY KEY (id_uzivatel)
);

--vytvoreni tabulky Pracovnik
create table Pracovnik (
   id_uzivatel INTEGER NOT NULL,
   cislo_uctu VARCHAR(16),

    CONSTRAINT FK_uzivatel_pracovnik FOREIGN KEY (id_uzivatel) REFERENCES Uzivatel,
    CONSTRAINT PK_pracovnik PRIMARY KEY (id_uzivatel)
);

--vytvoreni tabulky Rezervace
create table Rezervace (
    cislo_rezervace INTEGER NOT NULL,
    datum_rezervace DATE,
    platnost NUMBER(1), --boolean neni v oracle, takze nahrada bude 1-true, 0-false
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
    cislo_vypujcka INTEGER NOT NULL,
    datum_vypujcka DATE,
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
