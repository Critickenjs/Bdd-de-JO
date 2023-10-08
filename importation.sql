DROP TABLE import cascade ;
DROP TABLE noc cascade;
DROP TABLE jo cascade;
DROP TABLE athlete cascade;
DROP TABLE sports cascade;
DROP TABLE participe;


CREATE  TABLE import (
  id int, 
  name text,
  sexe char(1), 
  age int, 
  taille int, 
  poids float, 
  equipe text,
  noc char(3),
  jeu text,
  annee int,
  saison char(10),
  ville text,
  sport text,
  epreuve text,
  medaille char(10));

CREATE  TABLE NOC (
  noc char(3), 
  pays text, 
  description text);

\copy import from athlete_events.csv with (format CSV , delimiter ',' , null 'NA',header) where annee >=1920 and Sport != 'Art Competitions';
\copy noc from noc_regions.csv with(format csv , delimiter ',' , header );


CREATE TABLE athlete(ano,name,sexe,taille,poid) 
  as select distinct id, name,sexe,taille,poids from import;

ALTER TABLE athlete ADD PRIMARY KEY(ano);

CREATE TABLE jo(jno serial,
                anne int ,
                jeu text,
                saison char(10),
                ville text);

INSERT INTO jo(anne ,jeu ,saison,ville) 
select distinct annee, jeu, saison, ville from import order by annee desc;

  ALTER TABLE jo add PRIMARY key(jno);

CREATE TABLE sports (sno serial,
                     sport text,
                     epreuve text);

insert into sports (sport, epreuve) select distinct sport,epreuve from import;

    ALTER TABLE sports add PRIMARY key(sno);
    
CREATE TABLE participe(jno int, 
                       ano int , 
                       sno int , 
                       noc char(3), 
                       equipe text, 
                       age int , 
                       medaille char(10));

insert into participe  (jno ,ano , sno, noc, equipe, age, medaille) 
  select jno, id, sno,noc, equipe,age,medaille from import as i, sports as s, jo 
  where s.sport = i.sport and i.epreuve = s.epreuve and jo.ville = i.ville and i.annee = jo.anne;

ALTER TABLE participe ADD PRIMARY KEY(ano,jno,sno,noc);

