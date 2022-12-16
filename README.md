# SQL-Analyses_sujets_televises_Chaines_FRANCE_2005_2020

Sources de la BDD :

Cette base de données est issuée du site data.gouv.fr
"Classement thématique des sujets de journaux télévisés (janvier 2005 - septembre 2020)"
https://www.data.gouv.fr/fr/datasets/classement-thematique-des-sujets-de-journaux-televises-janvier-2005-septembre-2020/


Description des colonnes : 

-- Les colonnes quantitatives totalisent les sujets diffusés sur les journaux télévisés du soir des six chaînes dites « historiques » (TF1, France 2, France 3, Canal +, Arte, M6);
-- Pour cette base de données nous avons 14 sujets (thématiques) enregistrées.
-- Chaque enregistrement (ligne) est fait au mois, c'est à dire pour un mois, nous avons 14 thématiques pour les six chaînes, de janvier 2005 - septembre 2020.

Les requêtes d'Analyes SQL :

Le travail se décompose en deux parties:

A)  La préparation des données pour les requêtes d'analyses:

 1) Récupérer les données du site data.gouv.fr, importer les données dans Microsoft SQL SERVER
 2) Afficher notre table
 3) Vérifier les types de colonnes;
 4) Vérifier les doublons;
 5) Vérifier les valeurs nulles.

B) Cette partie est dédiée aux requêtes d'analyses :

 1) Global journaux télévisés pour chaque chaîne et toutes les thématiques confondues;
 2) Pourcentage des journaux télévisés pour chaque chaîne et toutes les thématiques et années confondues;
 3) Journaux télévisés par année, chaînes et toutes les thématiques confondues;
 4) Thématiques télévisés pour toutes les chaînes et année confondues;
 5) Thématiques télévisés pour chaque chaîne et toutes les année confondues;
 6) Pour chaque thematique, quelle est la chaîne qui fait le plus de diffusion;
 7) Regardons la tendance des sujets télévisés d'année en année pour  toutes les chaînes et thématiques confondues;
 8) Regardons la variation des sujets télévisés d'année en année pour toutes les chaînes et thématiques confondues;
 9) Regardons le cummulative des sujets télévisés d'année en année pour chaque chaîne et toutes les thématiques confondues;
 10) Regardons la variation des sujets télévisés d'année en année pour chaque chaîne et toutes les thématiques confondues.
 
