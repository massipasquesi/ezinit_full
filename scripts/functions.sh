#!/bin/bash

# VARIABLES COULEURS
ENDCOLOR='\033[0m'
BLUE='\033[1;34m'
BLUE0='\033[0;34m'
GREEN='\033[1;32m'
GREEN0='\033[0;32m'
RED='\033[1;31m'
RED0='\033[0;31m'
VIOLET='\033[1;35m'
VIOLET0='\033[0;35m'
YELLOW='\033[1;33m'
YELLOW0='\033[0;33m'
TODO_COLOR='\033[0;34;47m'

# VARIABLES ERREURS
ERRORS_ARRAY=
E_CONNEXION=22
E_PARAMETRE=11
E_NOTERROR=99

# FONCTIONS

# @name goornotgo
# demande à l'utilisateur de donné une reponse de type y/n et retourne la reponse
#
# @param1(facultatif) : chaine pour la question
#
# @return 0 si la reponse est y ou Y
# @return 1 si la reponse est n ou N
# @return 99 si l'uitilisateur écrit autre choses
goornotgo()
{
	if [ "$1" != "" ]; then
		QUESTION=$1
	else
		QUESTION="continuer ?"
	fi
	read -p "$QUESTION (y/n) : " GO
	if [ "$GO" == "y" ] || [ "$GO" == "Y" ]; then
		return 0
	elif [ "$GO" == "n" ] || [ "$GO" == "N" ]; then
		return 1
	else
	{
		echo -e "$RED Il faut taper y ou n!! Pas $GO $ENDCOLOR"
		return 99
	}
	fi
}

# @name fileordir
# dit si le fichier en parametre existe et si est un fichier ou un dossier
#
# @ param1 : file
#
# @return 1 si est un fichier
# @return 2 s est un dossier
# @return 99 si le fichier est inexistant
fileordir()
{
	if [ -e "$1" ]; then
	{
		if [ -d "$1" ]; then
			echo -e "$BLUE info : $1 est un dossier $ENDCOLOR"
			return 2
		else
			echo -e "$BLUE info : $1 est un fichier $ENDCOLOR"
			return 1
		fi
	}
	else
		echo -e "$RED je ne trouve pas $1 ! $ENDCOLOR"
		return 99
	fi
}

# @name fileextension
# retourne l'extension du fichier
#
# @ param1 : file
# @ param2 : extension
#
# @return 0 et fait un echo de la chaine 'extension' si existe
# @return 99 si le fichier est inexistant
#
# @TODO : pour l'instant dans le cas d'une double extension on gére seulement celle qui commencent par 'tar' ( faire une liste de double extension possibles ? )
fileextension()
{
	if [ -e "$1" ]; then
		EXT="${1##*.}"
		CHAINE="${1%.*}"
		if [ "$EXT" != "tar" ] && [ "${CHAINE##*.}" == "tar" ]; then
			EXT="${CHAINE##*.}.$EXT"
		fi
		echo "${EXT}"
		return 0;
	else
		echo -e "$RED je ne trouve pas $1 ! $ENDCOLOR"
		return 99
	fi
}

# @name uncompress
# decompresse un archive
#
# @param1 : fichier source eZPublish 
# @param2 : extension du fichier
#
# @TODO : quoi faire si on a pas passé de parametres ?
# @TODO : gerer plus de type d'archives et gerer les erreur de shell
uncompress() {
	if [ -f "$1" ]; then 
		case "$2" in
			tar)
			   tar -xvf $1
			;;
			tar.gz)
			   tar -zxvf $1
			;;
			zip)
			   unzip -q $1
			;;
			*)
				echo -e "$RED $1 n'est pas une archive zip ou tar ou tar.gz ! $ENDCOLOR"
				echo -e "$TODO_COLOR todo : inclure d'autres type d'archive dans la fonction 'uncompress()' $ENDCOLOR"
				return 9;
			;;
		esac
	else
		echo -e "$RED je ne trouve pas $1 ou ce n'est pas un fichier ! $ENDCOLOR"
		return 99
	fi

	return 0
}


# @name mysqlerrconnexion
# execute des actions dans le cad'un echec de connexion mysql
# @return E_CONNEXION
mysqlerrconnexion() {
    echo -e "$RED mysql user et/ou password ne sont pas valides !$ENDCOLOR\n"
    mysqlerr=1
    return $E_CONNEXION
}


# @name testmysqlconnexions
# teste la connexion mysql
# demande en prompt user et mdp et les enregistre avec un EXPORT
# @return : E_CONNEXION si il y a erreur, 0 si connexion OK
# @TODO : si erreur connexion donner la possibilité de nouvelle tentative
testmysqlconnexion() {
	if [ "$MYSQLUSR" != "" ]; then
		return 0
	fi

	mysqlerr=0
	read -p "mysql user ? " mysqlusr
	read -sp "mysql password ? " mysqlpswd
	
	echo "exit" | mysql -u $mysqlusr -p$mysqlpswd || mysqlerrconnexion 2>&1

	if [ "$mysqlerr" = "1" ]; then
		return $E_CONNEXION
	fi

	export MYSQLUSR=${mysqlusr}
	export MYSQLPSWD=${mysqlpswd}

	return 0
}


# @name mysqlexec
# execute des operations mysql
# @param1 : "f" ou "e"
# @param2 : si "f" fichier.sql; si "e" statement
# @TODO : quoi faire si on a pas passé de parametres ?
mysqlexec() {
	testmysqlconnexion 2>&1
	local cnx=$?
	#echo -e "\n$MYSQLUSR $MYSQLPSWD\n"

    if [ $cnx -ne 0 ]; then
        return $E_CONNEXION
    fi
	if [ "$1" == "f" ]; then
        if [ "$MYSQLPSWD" == "" ]; then
            mysql -u $MYSQLUSR --default-character-set=utf8 < "$2"
        else
            mysql -u $MYSQLUSR -p$MYSQLPSWD --default-character-set=utf8 < temp_ezinitdb.sql
        fi
    elif [ "$1" == "e" ]; then
        if [ "$MYSQLPSWD" == "" ]; then
            mysql -u $MYSQLUSR --default-character-set=utf8 -e "$2"
        else
            mysql -u $MYSQLUSR -p$MYSQLPSWD --default-character-set=utf8 -e "$2"
        fi
	else
		echo -e "$RED option -$1 n'existe pas ! $ENDCOLOR"
		return $E_PARAMETRE
	fi

	return 0
}