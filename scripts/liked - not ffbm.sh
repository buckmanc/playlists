
#script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
script_dir="/media/content/Dropbox/spotify_playlist_generator_config/Playlists/scripts"

inputPath="$script_dir/../Top/Top - Female Fronted Black Metal Plus.txt"
outputPath="$script_dir/../Liked Genre/Liked - Not FFBM.txt"

echo "@Default:LikesByArtist" > "$outputPath"
echo "@UpdateSort" >> "$outputPath"
echo "# a playlist for all the completely incidental cool stuff I found while trimming down those female fronted black metal lists" >> "$outputPath"
echo "" >> "$outputPath"

cat "$inputPath" | grep -iPo '^-artist\:\K(.+?)$' | sort | uniq -iu >> "$outputPath"
