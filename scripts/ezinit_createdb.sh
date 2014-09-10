#!/bin/bash

# INCLUDES
source functions.sh
source header.h


if [ -z "$1" ]; then
    # demande le nom à donner au projet
    read -p 'nom du projet? : ' PROJNAME
else
    PROJNAME=$1
fi

JUMP=false
# CRÉE LA BASE DONNÉ MYSQL POUR LE PROJET
# se deplace dans le dossier $WORKPATH
cd $WORKPATH/

# copie le fichier $MODELEMYSQL si existe
# sinon demande le nom du fichier modele mysql et son chemin
if [ -e $MODELEMYSQL ]; then
	cp -f $MODELEMYSQL temp_ezinitdb.sql
else
{
	# demande un chemin pour le modele mysql et copie le fichier donné en prompt si existe
	# sinon affiche un message d'erreur et quitte le script
	read -p 'chemin et nom du modele mysql (create database) : ' MODELEMYSQL
	if [ -e "$MODELEMYSQL" ]; then
		cp -f $MODELEMYSQL temp_ezinitdb.sql
	else
	{
		echo -e "$RED je n'arrive pas à trouver $MODELEMYSQL"
		echo -e "La base de donné devra être crée manuellement ! $ENDCOLOR"
        JUMP=true
        # cette ligne est rajouté pour le script sous part
        exit -1;
	}
	fi
}
fi

if [ "$JUMP" == false ]; then
{
    # remplace les occurences '{NAME}' par le nom du projet
    sed -i "s/{NAME}/$PROJNAME/g" temp_ezinitdb.sql

    # ouvre le fichier sql crée pour verifier que tout va bien ;)
    $TXTED temp_ezinitdb.sql 

    # attend que la verification manuelle soit terminé (fermeture de $TXTED)
    wait

    # se connecte à mysql et execute le create database statement
    mysqlexec "f" "temp_ezinitdb.sql" 2>&1
    #echo $?

    # supprime temp_ezinitdb.sql
    rm -v temp_ezinitdb.sql
}
fi

exit 0;
