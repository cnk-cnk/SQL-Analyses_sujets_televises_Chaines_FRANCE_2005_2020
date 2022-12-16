USE JOURNAL_TELEVISE
GO

--A: Cette partie est pour la pr�paration des donn�es pour les requ�tes d'analyses. 

    /* Nous allons r�cup�rer les donn�es, v�rifier les types de colonnes, v�rifier les doublons, v�rifiers les valeurs nulles */


-- Nous n'avons qu'une seule table "JT_TV$"

--1 Affichons notre table
SELECT * FROM JT_TV$

-- Nous constatons que la colonne DATE est en datetime ... il faut passer les donn�es au type date

-- 2 Modifier le type de la colonne 

/* ALTER TABLE JT_TV$
ALTER COLUMN DATE date

Cette action est permanente � ne pas refaire plusieurs fois..
*/

-- Affichons notre table pour voir si c'est ok 
SELECT * FROM JT_TV$

-- conclusion c'est ok

--3 V�rifions que nous n'avons pas des doublons

/* NB: la table n'est pas sens� contenir des doublons. Les colonnes: DATE, chaine et THEMATIQUES veille � cela ... 
 C'est � dire nous ne pouvons pas avoir deux lignes (>=2) de la table avec pour meme valeur consitu� des colonnes: DATE, chaine et THEMATIQUES */

 SELECT DATE,THEMATIQUES,cha�ne, COUNT(*) FROM JT_TV$ 
 GROUP BY DATE,THEMATIQUES,cha�ne
 HAVING COUNT(*)>1

-- Conclusion : nous n'avons aucune ligne retourn�e avec un COUNT (*)  de > 1, si c'�tait le cas, �a impliquerait des doublons ...qu'il faudra supprimer

-- 4 V�rifions si nous avons des valeurs nulles pour les diff�rentes colonnes 

SELECT * FROM JT_TV$ 
WHERE DATE IS NULL or  THEMATIQUES IS NULL or Nombre_de_sujet_journaux_t�l�vis�s IS NULL or cha�ne IS NULL 

-- Conclusion aucune valeur nulle pour cette table



--B: Cette partie est d�di�e aux requ�tes d'analyses

-- 5 : Global journaux t�l�vis�s pour chaque cha�ne et toutes les th�matiques confondues
SELECT * FROM JT_TV$ 

SELECT cha�ne, SUM (Nombre_de_sujet_journaux_t�l�vis�s)  Total_sujet_journaux_t�l�vis�s FROM JT_TV$ 
GROUP BY  cha�ne
ORDER BY SUM (Nombre_de_sujet_journaux_t�l�vis�s) desc

-- 6 : Pourcentage des journaux t�l�vis�s pour chaque cha�ne et toutes les th�matiques et ann�es confondues;
SELECT cha�ne, SUM (Nombre_de_sujet_journaux_t�l�vis�s)  Total_JT_par_cha�ne, SUM (SUM (Nombre_de_sujet_journaux_t�l�vis�s)) OVER () Total_JT_cha�ne_confondus,
CAST ((SUM (Nombre_de_sujet_journaux_t�l�vis�s))*100/(SUM (SUM (Nombre_de_sujet_journaux_t�l�vis�s)) OVER ()) as numeric(5,2)) as Pct_Total_JT_par_cha�ne
FROM JT_TV$ 
GROUP BY  cha�ne
ORDER BY SUM (Nombre_de_sujet_journaux_t�l�vis�s) desc

-- 7 : Journaux t�l�vis�s par ann�e, cha�nes et toutes les th�matiques confondues

SELECT  YEAR(DATE) Year_, cha�ne, SUM (Nombre_de_sujet_journaux_t�l�vis�s) Total_JT_par_ann�e_cha�ne FROM JT_TV$
-- WHERE YEAR(DATE) IN ( 2005, 2006) ... vous pouvez filtrez pour l'ann�e qui vous interesse avec la clause "WHERE et l'operateur IN, = ....
GROUP BY YEAR(DATE),cha�ne
ORDER BY YEAR(DATE) 

-- 8 : Th�matiques t�l�vis�s pour toutes les chaines et ann�e confondues
SELECT  * FROM JT_TV$

SELECT THEMATIQUES, SUM (Nombre_de_sujet_journaux_t�l�vis�s) Total_JT_par_th�matique FROM JT_TV$
GROUP BY THEMATIQUES
ORDER BY SUM (Nombre_de_sujet_journaux_t�l�vis�s) desc


-- 9 : Th�matiques t�l�vis�s pour chaque cha�ne et toutes les ann�es confondues
SELECT  * FROM JT_TV$

SELECT THEMATIQUES,cha�ne, SUM (Nombre_de_sujet_journaux_t�l�vis�s) Total_JT_par_th�matique FROM JT_TV$
GROUP BY THEMATIQUES,cha�ne
ORDER BY THEMATIQUES, SUM (Nombre_de_sujet_journaux_t�l�vis�s) desc


-- 10 : Pour chaque thematique, quelle est la cha�ne qui fait le plus de diffusion ?
SELECT  * FROM JT_TV$

WITH table_1 as(

SELECT THEMATIQUES,cha�ne, SUM (Nombre_de_sujet_journaux_t�l�vis�s) Total_JT_par_th�matique,
MAX(SUM (Nombre_de_sujet_journaux_t�l�vis�s)) OVER (PARTITION BY THEMATIQUES)  Max_JT
FROM JT_TV$
GROUP BY THEMATIQUES,cha�ne
--ORDER BY THEMATIQUES, SUM (Nombre_de_sujet_journaux_t�l�vis�s) desc
)

SELECT a.THEMATIQUES, a.cha�ne,a.Total_JT_par_th�matique, b.Distinct_Max_JT FROM table_1 as a
JOIN  (SELECT DISTINCT(Max_JT) Distinct_Max_JT FROM table_1 ) as b
ON  a.Total_JT_par_th�matique=b.Distinct_Max_JT
ORDER BY a.Total_JT_par_th�matique desc



-- 11: Regardons la tendance des sujets t�l�vis�s d'ann�e en ann�e pour  toutes les cha�nes et th�matiques confondues

SELECT  * FROM JT_TV$

SELECT Year(DATE) Ann�e, SUM (Nombre_de_sujet_journaux_t�l�vis�s) Total_JT_par_ann�e, SUM(SUM (Nombre_de_sujet_journaux_t�l�vis�s)) OVER () Grand_Total_JT,
ROUND((SUM (Nombre_de_sujet_journaux_t�l�vis�s))*100/SUM(SUM (Nombre_de_sujet_journaux_t�l�vis�s)) OVER () , 2) Pct_Total_JT_par_ann�e
FROM JT_TV$
GROUP BY Year(DATE)
ORDER BY Year(DATE)


-- 12 :  Regardons la variation des sujets t�l�vis�s d'ann�e en ann�e pour toutes les cha�nes et th�matiques confondues

SELECT  * FROM JT_TV$

SELECT Year(DATE) Ann�e, SUM (Nombre_de_sujet_journaux_t�l�vis�s) Actuelle_Total_JT_par_ann�e, LAG(SUM (Nombre_de_sujet_journaux_t�l�vis�s),1,0) OVER (ORDER BY Year(DATE)) Pr�c�dente_Total_JT_par_ann�e,
(SUM (Nombre_de_sujet_journaux_t�l�vis�s)) - (LAG(SUM (Nombre_de_sujet_journaux_t�l�vis�s),1,0) OVER (ORDER BY Year(DATE))) difference_Actuelle_moin_Pr�c�dente,
CASE 
WHEN  LAG(SUM (Nombre_de_sujet_journaux_t�l�vis�s),1,0) OVER (ORDER BY Year(DATE)) = 0 THEN ''
ELSE  ROUND(((SUM (Nombre_de_sujet_journaux_t�l�vis�s)) - (LAG(SUM (Nombre_de_sujet_journaux_t�l�vis�s),1,0) OVER (ORDER BY Year(DATE))))*100/LAG(SUM (Nombre_de_sujet_journaux_t�l�vis�s),1,0) OVER (ORDER BY Year(DATE)), 2)
END Pct_Variation
FROM JT_TV$
GROUP BY Year(DATE)
ORDER BY Year(DATE)



-- 13 Regardons le cummulative des sujets t�l�vis�s d'ann�e en ann�e pour chaque cha�ne et toutes les th�matiques confondues

SELECT cha�ne, Year(DATE) Ann�e, SUM (Nombre_de_sujet_journaux_t�l�vis�s) Actuelle_Total_JT_par_ann�e, SUM(SUM (Nombre_de_sujet_journaux_t�l�vis�s)) OVER (PARTITION BY cha�ne) Total_par_cha�ne,
SUM(SUM (Nombre_de_sujet_journaux_t�l�vis�s)) OVER (PARTITION BY cha�ne ORDER BY Year(DATE))  Cummulative_Total_par_cha�ne
FROM JT_TV$
GROUP BY cha�ne, Year(DATE)
ORDER BY cha�ne, Year(DATE)


-- 14 Regardons la variation des sujets t�l�vis�s d'ann�e en ann�e pour chaque cha�ne et toutes les th�matiques confondues

SELECT  * FROM JT_TV$

SELECT cha�ne, Year(DATE) Ann�e, SUM (Nombre_de_sujet_journaux_t�l�vis�s) Actuelle_Total_JT_par_ann�e, SUM(SUM (Nombre_de_sujet_journaux_t�l�vis�s)) OVER (PARTITION BY cha�ne) Total_par_cha�ne,
LAG(SUM (Nombre_de_sujet_journaux_t�l�vis�s),1,0) OVER (PARTITION BY cha�ne ORDER BY Year(DATE)) Pr�c�dente_Total_JT_par_ann�e,
SUM (Nombre_de_sujet_journaux_t�l�vis�s) -  LAG(SUM (Nombre_de_sujet_journaux_t�l�vis�s),1,0) OVER (PARTITION BY cha�ne ORDER BY Year(DATE)) difference_Actuelle_Pr�c�dente,
CASE 
WHEN  LAG(SUM (Nombre_de_sujet_journaux_t�l�vis�s),1,0) OVER (PARTITION BY cha�ne ORDER BY Year(DATE)) = 0 THEN  ''
ELSE  ROUND(((SUM (Nombre_de_sujet_journaux_t�l�vis�s) -  LAG(SUM (Nombre_de_sujet_journaux_t�l�vis�s),1,0) OVER (PARTITION BY cha�ne ORDER BY Year(DATE))))*100 / (LAG(SUM (Nombre_de_sujet_journaux_t�l�vis�s),1,0) OVER (PARTITION BY cha�ne ORDER BY Year(DATE))),2)
END   AS Pct_Variation_Actuelle_Pr�c�dente_JT
FROM JT_TV$
GROUP BY cha�ne, Year(DATE)
ORDER BY cha�ne, Year(DATE)