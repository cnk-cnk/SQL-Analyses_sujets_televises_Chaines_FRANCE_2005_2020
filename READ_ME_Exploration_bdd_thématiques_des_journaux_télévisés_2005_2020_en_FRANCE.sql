/*

Sources de la BDD :

Cette base de donn�es est issu�e du site data.gouv.fr
"Classement th�matique des sujets de journaux t�l�vis�s (janvier 2005 - septembre 2020)"
https://www.data.gouv.fr/fr/datasets/classement-thematique-des-sujets-de-journaux-televises-janvier-2005-septembre-2020/


Description des colonnes : 

-- Les colonnes quantitatives totalisent les sujets diffus�s sur les journaux t�l�vis�s du soir des six cha�nes dites � historiques � (TF1, France 2, France 3, Canal +, Arte, M6);
-- Pour cette base de donn�es nous avons 14 sujets (th�matiques) enregistr�es.
-- Chaque enregistrement (ligne) est fait au mois, c'est � dire pour un mois, nous avons 14 th�matiques pour les six cha�nes, de janvier 2005 - septembre 2020.

Les requ�tes d'Analyes SQL :

Le travail se d�compose en deux parties:

A)  La pr�paration des donn�es pour les requ�tes d'analyses:

 1) R�cup�rer les donn�es du site data.gouv.fr, importer les donn�es dans Microsoft SQL SERVER
 2) Afficher notre table
 3) V�rifier les types de colonnes;
 4) V�rifier les doublons;
 5) V�rifier les valeurs nulles.

B) Cette partie est d�di�e aux requ�tes d'analyses :

 1) Global journaux t�l�vis�s pour chaque cha�ne et toutes les th�matiques confondues;
 2) Pourcentage des journaux t�l�vis�s pour chaque cha�ne et toutes les th�matiques et ann�es confondues;
 3) Journaux t�l�vis�s par ann�e, cha�nes et toutes les th�matiques confondues;
 4) Th�matiques t�l�vis�s pour toutes les cha�nes et ann�e confondues;
 5) Th�matiques t�l�vis�s pour chaque cha�ne et toutes les ann�e confondues;
 6) Pour chaque thematique, quelle est la cha�ne qui fait le plus de diffusion;
 7) Regardons la tendance des sujets t�l�vis�s d'ann�e en ann�e pour  toutes les cha�nes et th�matiques confondues;
 8) Regardons la variation des sujets t�l�vis�s d'ann�e en ann�e pour toutes les cha�nes et th�matiques confondues;
 9) Regardons le cummulative des sujets t�l�vis�s d'ann�e en ann�e pour chaque cha�ne et toutes les th�matiques confondues;
 10) Regardons la variation des sujets t�l�vis�s d'ann�e en ann�e pour chaque cha�ne et toutes les th�matiques confondues.
 

 */



