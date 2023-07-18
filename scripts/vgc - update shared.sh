#need to modify this to work on start/end tags for the section
# so that --exclude-current-artist works and doesn't get overwritten

# head -n `grep -in -m 1 "\-\-shared avgc" avgc\ -\ auto\ candidates.txt | cut -f1 -d:` avgc\ -\ auto\ candidates.txt 

#script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
script_dir="/media/content/Dropbox/spotify_playlist_generator_config/Playlists/scripts"
playlist_dir="$script_dir/../vgc can"

count=0

cd "$playlist_dir"

#for FILE in avgc*.txt
#grep -il -m 1 "\-\-shared .*vgc" avgc*.txt | while read -r FILE
ls *vgc*.txt | while read -r FILE
	do
	
	# echo 'line number: '
	# grep -in -m 1 "\-\-shared avgc" "$FILE" | cut -f1 -d:
	echo "updating ${FILE}..."
	
	solo_deets=$(head -n `grep -in -m 1 "\-\-shared .*vgc" "$FILE" | cut -f1 -d:` "$FILE" | head -n -1)
	manual_ex=$(tail -n +`grep -in -m 1 "\-\-manual exclusions" "$FILE" | cut -f1 -d:` "$FILE" | tail -n +2)
	
	if [ "$solo_deets" == "" ];
	then
		solo_deets=$(cat "$FILE")
	fi
	
	if [ "$manual_ex" == "" ];
	then
		manual_ex=""
	fi
	
	# echo "solo_deets: $solo_deets"
	# echo "manual_ex: $manual_ex"
	
	#manual ex is being copied between files?
	
	avgc_shared_exclusions=$(cat "avgc - shared exclusions.log")
	pvgc_shared_exclusions=$(cat "pvgc - shared exclusions.log")
	vgc_shared_exclusions=$(cat "vgc - shared exclusions.log")

	echo "$solo_deets" > "$FILE"
	echo "" >> "$FILE"
	echo "# --shared vgc exclusions--" >> "$FILE"

	if [[ "$FILE" == avgc* ]]
	then
		echo "# --avgc--" >> "$FILE"
		echo "$avgc_shared_exclusions" >> "$FILE"
	fi

	if [[ "$FILE" == pvgc* ]]
	then
		echo "# --pvgc--" >> "$FILE"
		echo "$pvgc_shared_exclusions" >> "$FILE"
	fi

	echo "# --all vgc--" >> "$FILE"
	echo "$vgc_shared_exclusions" >> "$FILE"
	echo "" >> "$FILE"
	echo "# --manual exclusions--" >> "$FILE"
	echo "$manual_ex" >> "$FILE"
	#echo ""

	(( count++ ))
done

# echo "updated $count vgc specs"
echo "updated vgc specs"

