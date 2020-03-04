#!/bin/bash

help()
{
	cat help.txt
}

save()
{
	XP=$OPTARG
	V1=$(df)
	V2=$(lsblk)
	Date=$(date)
	if [ -d "./ScriptSv/" ];then
		echo "$V1" > ./ScriptSv/$XP."$Date".txt	# transferer les informations dans un fichier.txt
		echo "$V2" >> ./ScriptSv/$XP."$Date".txt
	else
		mkdir ./ScriptSv
		echo "$V1" > ./ScriptSv/$XP."$Date".txt	# transferer les informations dans un fichier.txt
		echo "$V2" >> ./ScriptSv/$XP."$Date".txt
	fi
}

crb_lbk()
{
	V=$(lsblk) 
	echo "$V" > table.txt	# transferer les informations lsblk dans un fichier.txt
	gnuplot script.gnu -persist	# afficher courbe en fonction du volume (size)
	rm table.txt # supprimer le fichier.txt
}

crb_ldf()
{
	V=$(df)
	echo "$V" > table.txt	# transferer les informations df dans un fichier.txt
	gnuplot script2.gnu -persist	# afficher courbe en fonction des espaces disponibles (available)
	rm table.txt # supprimer le fichier.txt
}

Pchart_lbk()
{
	V=$(lsblk) 
	echo "$V" > table.txt	# transferer les informations lsblk dans un fichier.txt
	gnuplot script3.gnu -persist	# afficher courbe en fonction du volume (size)
	rm table.txt # supprimer le fichier.txt
}

Pchart_ldf()
{
	V=$(df)
	echo "$V" > table.txt	# transferer les informations df dans un fichier.txt
	gnuplot script3.gnu -persist	# afficher courbe en fonction des espaces disponibles (available)
	rm table.txt # supprimer le fichier.txt
}

search()
{
	Date=$OPTARG
	if [ -d "./ScriptSv/" ];then
		find ./ScriptSv/ -name "*$Date*"
	else
		echo "Erreur: le repertoire n'existe pas!"
	fi

}

graphic()
{
	yad --title="Peripherique et Courbes" \
	--text="<b><u>Faites votre choix:</u></b>"\
	--button="Quitter:0" \
	--button="Périphériques:1" \
	--button="Espace disque:2" \
	--button="Courbe Volume:3" \
	--button="Courbe Espaces Disponibles:4" 
    	case $? in
        	0)
           		exit;;
        	1)
            		lsblk;;
        	2)
           		df;;
        	3)
            		crb_lbk;;
        	4)
            		crb_ldf;;
    	esac
}


if [ $# = 1 ] || ([ "$1" = "-s" ] && [ $# = 2 ]) || ([ "$1" = "-o" ] && [ $# = 2 ]);then	# test de nombre d'options

	while getopts "hkfpcgs:o:" option
	do
	
		case $option in
			h) help # afficher le fichier text help
			;;
			k) lsblk # afficher les caractéristiques hardware via lsblk
			;;
			f)
			df # afficher les caractéristiques hardware via df
			;;
			p)
			crb_lbk	# appeler la fonction affichage courbe lsblk
			Pchart_lbk	# appeler la fonction camembert lsblk
			;;
			c)
			crb_ldf	# appeler la fonction affichage courbe df
			Pchart_ldf	# appeler la fonction camembert df
			;;
			g)
			graphic	# affichage interface graphique
			;;
			s)
			save	# sauvegarder dans un fichier
			;;
			o)
			search	# afficher le fichier du repertoire /Var/nom_script a partir de la date
			;;
			*) echo "Erreur: option invalide, utiliser l'option -h ou -help pour lancer la page d'aide."	# option invalide
			;;
		esac
	done
else
	echo "Erreur: nombre d'option invalide, utiliser l'option -h ou -help pour lancer la page d'aide." # afficher erreur
fi
