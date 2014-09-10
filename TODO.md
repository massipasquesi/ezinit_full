# @TODO 

## optimisation
* Separer les differentes etapes en functions ou scripts ->[^c]
* Faire une fonction pour suppresion ou autres operations sur les fichiers qui controle par exemple avant si le fichier existe
* Definir les codes d'erreur ->[^c]

## ezinit.sh
### à 2 ou 3 endroit dans le code
* faire une boucle la ou il y a 1 READ ( modèle mysql ou source EZ) jusque à que l'information donné est bonne

### à voir
* Verifier l'existance du dossier temp autrement le créer
* Il faudrait pouvoir configurer le nom du vhost et des url des sites eZPublish, comme pour l instant c est en local par default.
* parametrer ou demander user:group et mode pour le projet EZ

## functions.sh
### mysqlexec
* ~~demander en prompt user et mdp pour la connexion mysql~~
### testmysqlconnexion
* ~~verifier si $MYSQLUSER et $MYSQLPSWD sont definies~~
    * peut être les initialiser à NULL ?

## createdb
* ~~Ajouter un control aprés la mysqlexec et/ou tester la connexion avant~~
* ~~Supprimer le fichier temp\_ezinitdb.sql aprés utilisation~~
* remplacer le fichier 'temp\_ezinitdb.sql' par une variable ->[^c]
* nom de la base de donné peut être different du nom du projet
* montrer la liste des bdd aprés création


## paramètres
* Enlever des paramètres le dossier ezinit\_full pour le calculer dans le script ->[^c]
* ~~Supprimer les parametres user et mdp pour les demander en prompt~~
* Verifier les paramètres dans header.h avant de les utiliser
* Verifier que un projet et/ou une base de donnée avec le même nom n'existent pas déjà
* les noms des bases de donnée et donc du projet ne peuvent pas avoir de "-" ou autres symboles
  http://dev.mysql.com/doc/refman/5.0/fr/legal-names.html
  http://fr.openclassrooms.com/informatique/cours/administrez-vos-bases-de-donnees-avec-mysql/creation-d-une-base-de-donnees

## cleanup
* ls est double aprés suppression de l'instance web ! à corriger
* ajouter arguments pour single cleanup (db, vhost, proj-web, etc..)

## scrpts à faire
* script pour configurer le header interactivement
* help

## traductions
* anglais




[^c]: **en cours**