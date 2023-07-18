# playlists of songs I haven't liked by artists I have

#script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
script_dir="/media/content/Dropbox/spotify_playlist_generator_config/Playlists/scripts"

liked_dir="$script_dir/../Liked Genre/"
nolikeydir="$script_dir/../Likey No Likey/"
count=0

cd "$nolikeydir"

rm *.txt

cd "$liked_dir"

for FILE in *.txt
	do
	short_name_old=`basename "$FILE" .txt`
	short_name_new=$(echo "$short_name_old" | sed "s/Liked /Likey\ No\ Likey /")
	
	new_path=$nolikeydir$short_name_new\.txt
	
	echo "@NoLikes" >> "$new_path"
	echo "@LimitPerArtist:3" >> "$new_path"
	echo "@DeleteIfEmpty" >> "$new_path"
	echo "" >> "$new_path"
	echo "TopByArtistFromPlaylist:$short_name_old" >> "$new_path"
	cat "$liked_dir$FILE" | grep -iE ^- | grep -iEv ^-artist: >> "$new_path"

	(( count++ ))
done

echo "updated $count likey no likey playlist specs"
