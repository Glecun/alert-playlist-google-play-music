#Number of musics in playlists
nbLignesBibliotheque=$( grep "Library" playlists_export.csv | awk -F "\"*;;\"*" '{print $6}' | grep ^T | wc -l );
nbLignesJaime=$( grep "XXXYYYWWW" playlists_export.csv | awk -F "\"*;;\"*" '{print $6}' | grep ^T | wc -l );
printf "Nombre de titres dans Bibliotheque: $nbLignesBibliotheque \n";
printf "Nombre de titres dans XXXYYYWWW* : $nbLignesJaime \n";

#Number of difference
nbDiff=$(($nbLignesBibliotheque-$nbLignesJaime));
printf "\nDifference: $nbDiff \n\n";

#Songs not unique
printf "\n\n############# Voici les titres en double dans la bibliotheque: \n"
grep "Library" playlists_export.csv | awk -F "\"*;;\"*" '{print $6}' | grep ^T | sort | uniq -d	| grep -f - playlists_export.csv | grep "Library"
printf "\n\n############# Voici les titres en double dans les playlists XXXYYYWWW*: \n"
grep "XXXYYYWWW" playlists_export.csv | awk -F "\"*;;\"*" '{print $6}' | grep ^T | sort | uniq -d | grep -f - playlists_export.csv | grep "XXXYYYWWW"

if [ "$nbDiff" -ne 0 ]; then
	#If there is some differences
	grep "Library" playlists_export.csv | awk -F "\"*;;\"*" '{print $6}' | grep ^T > librarytmp.txt;
	grep "XXXYYYWWW" playlists_export.csv | awk -F "\"*;;\"*" '{print $6}' | grep ^T > thumbsuptmp.txt;

	printf "\n\n############# Voici les titres manquants dans la bibliotheque: \n"
	grep -iFxv -f librarytmp.txt thumbsuptmp.txt | grep -f - playlists_export.csv
	printf "\n\n############# Voici les titres manquants dans les playlists XXXYYYWWW*: \n"
	grep -iFxv -f thumbsuptmp.txt librarytmp.txt | grep -f - playlists_export.csv

	rm librarytmp.txt
	rm thumbsuptmp.txt

else
	#If there isn't any differences

	#Number of music manually added
	nbLignesManuallyAdded=$( cat playlists_export.csv | awk -F "\"*;;\"*" '{print $6}' | grep ^[^T] | grep -f - playlists_export.csv | grep "Library" | wc -l );
	printf "\n\nNombre de titres ajoute manuellement: $nbLignesManuallyAdded";

	printf "\n\n############# Voici les titres ajoute manuellement : \n"
	cat playlists_export.csv | awk -F "\"*;;\"*" '{print $6}' | grep ^[^T] | grep -f - playlists_export.csv | grep "Library"

	printf "\nAucune difference\n\n";
	nbLignes=$( grep "Library" playlists_export.csv | wc -l );
	printf "Exportation de $nbLignes titres: " ;
	grep "Library" playlists_export.csv > library.csv ;
	printf "Done ! \n";

fi
