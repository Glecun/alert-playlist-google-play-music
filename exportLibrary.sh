#Number of musics in playlists
nbLignesBibliotheque=$( grep "Library" playlists_export.csv | awk -F "\"*;;\"*" '{print $6}' | grep ^T | wc -l );
nbLignesJaime=$( grep "XXXYYYWWW" playlists_export.csv | awk -F "\"*;;\"*" '{print $6}' | grep ^T | wc -l );
printf "Nombre de titres dans Bibliotheque: $nbLignesBibliotheque \n";
printf "Nombre de titres dans J'aime : $nbLignesJaime \n";

#Number of difference
let nbDiff=$nbLignesBibliotheque-$nbLignesJaime;
printf "\nDifferenced: $nbDiff \n\n";

#Number of music manually added
nbLignesManuallyAdded=$( cat playlists_export.csv | awk -F "\"*;;\"*" '{print $6}' | grep ^[^T]  | wc -l );
printf "Nombre de titres ajoute manuellement: $nbLignesManuallyAdded \n\n";

printf "\n\n############# Voici les titres ajoute manuellement : \n"
cat playlists_export.csv | awk -F "\"*;;\"*" '{print $6}' | grep ^[^T]  | grep -f - playlists_export.csv

if [ "$nbDiff" -ne 0 ]; then
	#If there is some differences
	grep "Library" playlists_export.csv | awk -F "\"*;;\"*" '{print $6}' | grep ^T > librarytmp.txt;
	grep "XXXYYYWWW" playlists_export.csv | awk -F "\"*;;\"*" '{print $6}' | grep ^T > thumbsuptmp.txt;

	printf "\n\n############# Voici les titres manquants dans la bibliotheque: \n"
	grep -iFxv -f librarytmp.txt thumbsuptmp.txt | grep -f - playlists_export.csv
	printf "\n\n############# Voici les titres manquants dans la playlist J'aime: \n"
	grep -iFxv -f thumbsuptmp.txt librarytmp.txt | grep -f - playlists_export.csv
	
	rm librarytmp.txt
	rm thumbsuptmp.txt

else
	#If there isn't any differences
	printf "\nAucuned differences\n\n";
	nbLignes=$( grep "Library" playlists_export.csv | wc -l );
	printf "Exportation de $nbLignes titres: " ;
	grep "Library" playlists_export.csv > library.csv ;
	printf "Done ! \n";

fi

