# EZINIT\_FULL

**Un script bash pour automatiser l'installation d'une instance eZPublish sous Ubuntu & Debian.**

**_( testé sous ubuntu 11.04/12.04, debian 6/7 avec eZPublish 4.x,  mysql 5.x et apache 2 )_**

### OVERVIEW
Ce script fait :
 * extraire un archive ou copie un dossier existant d'une instance vierge EZ dans le repertoire des sites web
 * créer une base de donné pour l'instance EZ
 * créer un fichier vhost dans sites-available de apache
 * mettre à jour host dans /etc


Le projet comprends :
* models (dossier) :
 	* ez_generic_vhost (vhost generique pour eZPublish avec variables qui seront remplacé pendant l'execution du script)
	* ez_generic_initdb.sql (fichier generique sql pour la création de la base de donné avec variables qui seront remplacé pendant l'execution du script)
	* header (modèle pour header.h qui contient des variables à configurer, à copier et renommer en scripts/header.h)

* scripts (dossier) :
	* ezinit.sh (le script à lancer)
	* functions.sh (fichier qui contient des function utilisées par le script)
	* cleanup.sh ( script de nettoyage )


### CONFIG
Vous pouvez placer les deux modeles (ez_generic_vhost, ez_generic_initdb.sql) la ou vous voulez. (aussi les laisser ou ils sont ;)

**!!! Il faut copier et renommer le fichier models/header in scripts/header.h !!!**

La config se fait dans header.h :

```bash
# INIT VARIABLES
MODELESDIR="/path/to/ezinit_full/models" # chemin vers le dossiers des models
MODELEVH=$MODELESDIR"/ez_generic_vhost" # generic vhost
MODELEMYSQL=$MODELESDIR"/ez_generic_initdb.sql" # generic database create mysql
EZSOURCE="/path/to/ezpublish.zip" # instance ezpublish vierge (zip ou dossier)
WORKPATH="/tmp" # dossier pour créer des fichiers temporaires 
WEBPATH="/var/www" # chemin des projets web (par default /var/www)
ADRESSEIP="127.0.0.1" # adresse IP pour le site (normalement 127.0.0.1)
MYSQLUSR="user" # connexion à mysql : user et pswd
MYSQLPSWD="password"
TXTED="vim" # editeur de texte utilisé pendant l'execution du script (vim par default)
```

**! Le script utilise vim comme editeur de texte par default, 
donc si vous ne l'avez pas il faudra l'installer 
ou changer le paramètre TXTED dans le header avec le nom de l'executable de votre choix !**


### EXEC
Le script à lancer est ezinit.sh.

Pendant l'execution du script, on vous demandera le nom du projet, qui sera utilisé pour nommer le dossier de l'instance ezpublish, nommer la base de donné et configurere le vhost.

L'adresse du site eZPublish sera {nom_du_projet}.local et le BO admin.{nom_du_projet}.local .

Chaque fois que vim s'ouvre, c'est pour verifier que le traitement sur le fichier en question c'est bien passé. Si necessaire apporter les eventuelles modifications et puis fermer ! Le script attend la fermeture de vim pour continuer !


Dans le cas ou quelque chose c'est mal passé ou si on veut tout refaire,
le script cleanup.sh
s'occupe d'effacer tout ou seulement ce qu'on desire :
 - instance EZ
 - base de donné
 - vhost
 - entrées dans /etc/hosts


###@@@@@@@ Voir TODO @@@@@@@
Je pense que on peut faire pas mal d'ameliorations, donc n'hesitez pas à le reprendre e y travailler dessous si vous en avez envie ;)


