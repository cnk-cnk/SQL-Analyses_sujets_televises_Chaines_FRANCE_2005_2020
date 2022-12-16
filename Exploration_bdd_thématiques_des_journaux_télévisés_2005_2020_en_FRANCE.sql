USE JOURNAL_TELEVISE
GO

--A: Cette partie est pour la préparation des données pour les requêtes d'analyses. 

    /* Nous allons récupérer les données, vérifier les types de colonnes, vérifier les doublons, vérifiers les valeurs nulles */


-- Nous n'avons qu'une seule table "JT_TV$"

--1 Affichons notre table
SELECT * FROM JT_TV$

-- Nous constatons que la colonne DATE est en datetime ... il faut passer les données au type date

-- 2 Modifier le type de la colonne 

/* ALTER TABLE JT_TV$
ALTER COLUMN DATE date

Cette action est permanente à ne pas refaire plusieurs fois..
*/

-- Affichons notre table pour voir si c'est ok 
SELECT * FROM JT_TV$

-- conclusion c'est ok

--3 Vérifions que nous n'avons pas des doublons

/* NB: la table n'est pas sensé contenir des doublons. Les colonnes: DATE, chaine et THEMATIQUES veille à cela ... 
 C'est à dire nous ne pouvons pas avoir deux lignes (>=2) de la table avec pour meme valeur consitué des colonnes: DATE, chaine et THEMATIQUES */

 SELECT DATE,THEMATIQUES,chaîne, COUNT(*) FROM JT_TV$ 
 GROUP BY DATE,THEMATIQUES,chaîne
 HAVING COUNT(*)>1

-- Conclusion : nous n'avons aucune ligne retournée avec un COUNT (*)  de > 1, si c'était le cas, ça impliquerait des doublons ...qu'il faudra supprimer

-- 4 Vérifions si nous avons des valeurs nulles pour les différentes colonnes 

SELECT * FROM JT_TV$ 
WHERE DATE IS NULL or  THEMATIQUES IS NULL or Nombre_de_sujet_journaux_télévisés IS NULL or chaîne IS NULL 

-- Conclusion aucune valeur nulle pour cette table



--B: Cette partie est dédiée aux requêtes d'analyses

-- 5 : Global journaux télévisés pour chaque chaîne et toutes les thématiques confondues
SELECT * FROM JT_TV$ 

SELECT chaîne, SUM (Nombre_de_sujet_journaux_télévisés)  Total_sujet_journaux_télévisés FROM JT_TV$ 
GROUP BY  chaîne
ORDER BY SUM (Nombre_de_sujet_journaux_télévisés) desc

-- 6 : Pourcentage des journaux télévisés pour chaque chaîne et toutes les thématiques et années confondues;
SELECT chaîne, SUM (Nombre_de_sujet_journaux_télévisés)  Total_JT_par_chaîne, SUM (SUM (Nombre_de_sujet_journaux_télévisés)) OVER () Total_JT_chaîne_confondus,
CAST ((SUM (Nombre_de_sujet_journaux_télévisés))*100/(SUM (SUM (Nombre_de_sujet_journaux_télévisés)) OVER ()) as numeric(5,2)) as Pct_Total_JT_par_chaîne
FROM JT_TV$ 
GROUP BY  chaîne
ORDER BY SUM (Nombre_de_sujet_journaux_télévisés) desc

-- 7 : Journaux télévisés par année, chaînes et toutes les thématiques confondues

SELECT  YEAR(DATE) Year_, chaîne, SUM (Nombre_de_sujet_journaux_télévisés) Total_JT_par_année_chaîne FROM JT_TV$
-- WHERE YEAR(DATE) IN ( 2005, 2006) ... vous pouvez filtrez pour l'année qui vous interesse avec la clause "WHERE et l'operateur IN, = ....
GROUP BY YEAR(DATE),chaîne
ORDER BY YEAR(DATE) 

-- 8 : Thématiques télévisés pour toutes les chaines et année confondues
SELECT  * FROM JT_TV$

SELECT THEMATIQUES, SUM (Nombre_de_sujet_journaux_télévisés) Total_JT_par_thématique FROM JT_TV$
GROUP BY THEMATIQUES
ORDER BY SUM (Nombre_de_sujet_journaux_télévisés) desc


-- 9 : Thématiques télévisés pour chaque chaîne et toutes les années confondues
SELECT  * FROM JT_TV$

SELECT THEMATIQUES,chaîne, SUM (Nombre_de_sujet_journaux_télévisés) Total_JT_par_thématique FROM JT_TV$
GROUP BY THEMATIQUES,chaîne
ORDER BY THEMATIQUES, SUM (Nombre_de_sujet_journaux_télévisés) desc


-- 10 : Pour chaque thematique, quelle est la chaîne qui fait le plus de diffusion ?
SELECT  * FROM JT_TV$

WITH table_1 as(

SELECT THEMATIQUES,chaîne, SUM (Nombre_de_sujet_journaux_télévisés) Total_JT_par_thématique,
MAX(SUM (Nombre_de_sujet_journaux_télévisés)) OVER (PARTITION BY THEMATIQUES)  Max_JT
FROM JT_TV$
GROUP BY THEMATIQUES,chaîne
--ORDER BY THEMATIQUES, SUM (Nombre_de_sujet_journaux_télévisés) desc
)

SELECT a.THEMATIQUES, a.chaîne,a.Total_JT_par_thématique, b.Distinct_Max_JT FROM table_1 as a
JOIN  (SELECT DISTINCT(Max_JT) Distinct_Max_JT FROM table_1 ) as b
ON  a.Total_JT_par_thématique=b.Distinct_Max_JT
ORDER BY a.Total_JT_par_thématique desc



-- 11: Regardons la tendance des sujets télévisés d'année en année pour  toutes les chaînes et thématiques confondues

SELECT  * FROM JT_TV$

SELECT Year(DATE) Année, SUM (Nombre_de_sujet_journaux_télévisés) Total_JT_par_année, SUM(SUM (Nombre_de_sujet_journaux_télévisés)) OVER () Grand_Total_JT,
ROUND((SUM (Nombre_de_sujet_journaux_télévisés))*100/SUM(SUM (Nombre_de_sujet_journaux_télévisés)) OVER () , 2) Pct_Total_JT_par_année
FROM JT_TV$
GROUP BY Year(DATE)
ORDER BY Year(DATE)


-- 12 :  Regardons la variation des sujets télévisés d'année en année pour toutes les chaînes et thématiques confondues

SELECT  * FROM JT_TV$

SELECT Year(DATE) Année, SUM (Nombre_de_sujet_journaux_télévisés) Actuelle_Total_JT_par_année, LAG(SUM (Nombre_de_sujet_journaux_télévisés),1,0) OVER (ORDER BY Year(DATE)) Précédente_Total_JT_par_année,
(SUM (Nombre_de_sujet_journaux_télévisés)) - (LAG(SUM (Nombre_de_sujet_journaux_télévisés),1,0) OVER (ORDER BY Year(DATE))) difference_Actuelle_moin_Précédente,
CASE 
WHEN  LAG(SUM (Nombre_de_sujet_journaux_télévisés),1,0) OVER (ORDER BY Year(DATE)) = 0 THEN ''
ELSE  ROUND(((SUM (Nombre_de_sujet_journaux_télévisés)) - (LAG(SUM (Nombre_de_sujet_journaux_télévisés),1,0) OVER (ORDER BY Year(DATE))))*100/LAG(SUM (Nombre_de_sujet_journaux_télévisés),1,0) OVER (ORDER BY Year(DATE)), 2)
END Pct_Variation
FROM JT_TV$
GROUP BY Year(DATE)
ORDER BY Year(DATE)



-- 13 Regardons le cummulative des sujets télévisés d'année en année pour chaque chaîne et toutes les thématiques confondues

SELECT chaîne, Year(DATE) Année, SUM (Nombre_de_sujet_journaux_télévisés) Actuelle_Total_JT_par_année, SUM(SUM (Nombre_de_sujet_journaux_télévisés)) OVER (PARTITION BY chaîne) Total_par_chaîne,
SUM(SUM (Nombre_de_sujet_journaux_télévisés)) OVER (PARTITION BY chaîne ORDER BY Year(DATE))  Cummulative_Total_par_chaîne
FROM JT_TV$
GROUP BY chaîne, Year(DATE)
ORDER BY chaîne, Year(DATE)


-- 14 Regardons la variation des sujets télévisés d'année en année pour chaque chaîne et toutes les thématiques confondues

SELECT  * FROM JT_TV$

SELECT chaîne, Year(DATE) Année, SUM (Nombre_de_sujet_journaux_télévisés) Actuelle_Total_JT_par_année, SUM(SUM (Nombre_de_sujet_journaux_télévisés)) OVER (PARTITION BY chaîne) Total_par_chaîne,
LAG(SUM (Nombre_de_sujet_journaux_télévisés),1,0) OVER (PARTITION BY chaîne ORDER BY Year(DATE)) Précédente_Total_JT_par_année,
SUM (Nombre_de_sujet_journaux_télévisés) -  LAG(SUM (Nombre_de_sujet_journaux_télévisés),1,0) OVER (PARTITION BY chaîne ORDER BY Year(DATE)) difference_Actuelle_Précédente,
CASE 
WHEN  LAG(SUM (Nombre_de_sujet_journaux_télévisés),1,0) OVER (PARTITION BY chaîne ORDER BY Year(DATE)) = 0 THEN  ''
ELSE  ROUND(((SUM (Nombre_de_sujet_journaux_télévisés) -  LAG(SUM (Nombre_de_sujet_journaux_télévisés),1,0) OVER (PARTITION BY chaîne ORDER BY Year(DATE))))*100 / (LAG(SUM (Nombre_de_sujet_journaux_télévisés),1,0) OVER (PARTITION BY chaîne ORDER BY Year(DATE))),2)
END   AS Pct_Variation_Actuelle_Précédente_JT
FROM JT_TV$
GROUP BY chaîne, Year(DATE)
ORDER BY chaîne, Year(DATE)