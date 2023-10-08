--exercice 3) question 1: on trouve 15 colonnes.
SELECT COUNT() 
    FROM INformation_schema.columns WHERE table_name ='import';

-- question 2: il y a 255080 lignes
SELECT COUNT() FROM import;

--question 3: il y a 230 code NOC.
SELECT count(DISTINCT id) FROM noc;*

--question 4:il y a 127 575athletes.
SELECT count(DISTINCT id) FROM import;

--questions 5: il y a 12 116 médaille d'or
SELECT count() FROM import WHERE  medaille = 'Gold';

--question 6: il y a 2 ligne en reference a Carl lewis.
SELECT count() FROM import WHERE  name like   'Carl Lewis%'; 

--exercise 5):question 1

SELECT DISTINCT count(participe.noc) AS p, noc.pays 
    FROM participe 
        JOIN NOC USING (noc) 
    GROUP BY noc.pays 
    ORDER BY p DESC ;

--question 2

SELECT DISTINCT count(*) AS p, noc.pays 
    FROM participe 
        JOIN NOC USING (noc)
    WHERE medaille = 'Gold'
    GROUP BY noc.pays 
    ORDER BY p DESC;
--question 3

SELECT DISTINCT count(participe.noc) AS p, noc.pays 
    FROM participe 
        JOIN NOC USING (noc) 
    WHERE medaille IS NOT NULL 
    GROUP BY noc.pays 
    ORDER BY p DESC ;

--question 4

SELECT DISTINCT participe.ano, athlete.name, count(medaille) AS p
    FROM participe 
        JOIN athlete USING(ano) 
    WHERE medaille = 'Gold' 
    GROUP BY athlete.name,participe.ano 
    ORDER BY p DESC ;

--question 5

SELECT DISTINCT noc.pays, count(participe.medaille) p
    FROM participe,noc,jo
    WHERE medaille IS NOT NULL 
        AND jo.ville='Albertville' 
        AND jo.jno=participe.jno 
        AND noc.noc=participe.noc 
    GROUP BY noc.pays
    ORDER BY p DESC;

--question 6 

SELECT count(DISTINCT a.name) 
    FROM participe AS p 
        JOIN jo AS j USING(jno) 
        JOIN participe AS p2 USING(ano)
        JOIN athlete AS a USING(ano)
    WHERE p2.noc <> p.noc 
        AND p2.noc IN (SELECT DISTINCT noc FROM noc WHERE pays='France')
        AND p2.jno<p.jno;

--question 6-bis

SELECT a.name,COUNT(*) as nb_medaille
    FROM participe JOIN athlete AS a USING(ano)
    WHERE a.name IN(SELECT  a.name
                        FROM participe AS p 
                            JOIN jo AS j USING(jno) 
                            JOIN participe AS p2 USING(ano)
                            JOIN athlete AS a USING(ano)
                        WHERE p2.noc <> p.noc 
                            AND p2.noc IN (SELECT DISTINCT noc 
                                            FROM noc 
                                            WHERE pays='France') 
                            AND p2.jno<>p.jno 
                            AND p2.jno<p.jno)
        AND medaille  IS NOT NULL
    GROUP BY a.name
    ORDER BY COUNT(*) DESC
    LIMIT 1;



--question 7
SELECT count(DISTINCT a.name) 
    FROM participe AS p 
        JOIN jo AS j USING(jno) 
        JOIN participe AS p2 USING(ano) 
        JOIN athlete AS a USING(ano)
    WHERE p2.noc <> p.noc
        AND p.noc IN (SELECT DISTINCT noc 
                        FROM noc 
                        WHERE pays='France') 
        AND p2.jno<>p.jno 
        AND p2.jno<p.jno;

--question 7-bis
SELECT a.name,COUNT(*) as nb_medaille
    FROM participe p JOIN athlete AS a USING(ano)
    WHERE a.name IN(SELECT  a.name
                        FROM participe AS p 
                            JOIN jo AS j USING(jno) 
                            JOIN participe AS p2 USING(ano) 
                            JOIN athlete AS a USING(ano)
                        WHERE p2.noc <> p.noc
                            AND p.noc in (SELECT DISTINCT noc 
                                            FROM noc 
                                            WHERE pays='France') 
                            AND p2.jno<>p.jno 
                            AND p2.jno<p.jno)
    AND medaille  IS NOT NULL
        GROUP BY a.name
        ORDER BY COUNT(*) DESC
        LIMIT 1;

--question 8

SELECT age, COUNT(*) AS nb_medaille
    FROM participe
    where medaille ='Gold' 
        AND age IS NOT NULL
    GROUP BY age;

--duestion 9

SELECT s.sport,avg(p.age) AS age_moyen
    FROM participe AS p 
        JOIN sports AS s USING(sno)
    where medaille IS NOT NULL 
        AND age >=50
    GROUP BY s.sport
    ORDER BY avg(p.age) DESC;
                        
--question 10

SELECT j.jeu,j.ville, count(distinct p.sno) AS nb_epreuve
    FROM participe p 
        JOIN jo AS j USING(jno)
    GROUP BY j.jeu,j.ville, j.anne
    ORDER BY j.anne;

--question 11

SELECT j.jeu, count(*) AS nb_medaille
    FROM participe p 
        JOIN jo AS j USING(jno) 
        JOIN athlete AS a USING(ano)
    where sexe ='F' 
        AND j.saison='Summer' 
        AND medaille IS NOT NULL
    GROUP BY j.jeu
    ORDER BY count(*);

--exrcice 6

--  Le nombre médaille obtenu par des femme de l'équipe de france

SELECT count(*) AS nb_medaille
    FROM participe 
        JOIN noc n USING(noc) 
        JOIN athlete a USING(ano)
    Where medaille IS NOT NULL 
        AND n.pays = 'France' 
        AND a.sexe ='F';

-- Le nombre médaille obtenu par des athelètes de l'équipe de france par épreuve 

SELECT s.sport, s.epreuve , count(sno) AS nb_medailler
    FROM participe 
        JOIN noc n USING(noc) 
        JOIN sports s USING(sno) 
        JOIN jo USING(jno) 
    Where medaille IS NOT NULL 
        AND n.pays = 'France' 
    GROUP BY s.epreuve,s.sport 
    ORDER BY nb_medailler DESC; 

-- Le nombre d'athelète de l'équipe de france qui participe par jeu olympique et le nombre d'atlète repartie avec une médaille.

SELECT jo.jeu, COUNT(DISTINCT p.ano) AS nb_athletes, 
       COUNT(CASE WHEN p.medaille IS NOT NULL then 1 end) AS nb_medaille
    FROM participe p 
        JOIN noc n USING(noc) 
        JOIN jo USING(jno)
    WHERE n.pays = 'France'
    GROUP BY jo.jeu;

-- Taille et poid moyen des athelètes de l'équipe de france pour l'escrime.

SELECT jo.jeu, AVG(a.taille) as taille_moyen, AVG(a.poid) as poid_moyen
    FROM participe
        JOIN noc USING(noc) 
        JOIN jo USING(jno)
        JOIN athlete a USING(ano)
        JOIN sports s using(sno)
    WHERE noc.pays ='France' and  s.sport = 'Fencing'
    GROUP BY jo.jeu
    order by jo.jeu DESC;
