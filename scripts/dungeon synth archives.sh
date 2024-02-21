#!/usr/bin/env bash

script_dir="/media/content/Dropbox/spotify_playlist_generator_config/Playlists/scripts"
last_run_path="$script_dir/dsalastrun.log"
raw_log_path="$script_dir/dsa_title_log.log"
playlist_path="$script_dir/../Full Discog/Full Discog - Dungeon Synth Archives.txt"

if [[ ! -f "${playlist_path}" ]]
then
	base='
@Default:Album
@DontRemoveTracks
@AddParameterIDs
@Sort:Dont

'
	echo "${base}" > "${playlist_path}"
else
	# comment out any items that couldn't be found on previous runs to save time and api hits
	# strip prior comment for readability
	perl -i -pe 's/(^[^#].+?)#\s*Could not find.+/# \1/g' "${playlist_path}"
fi

if [ -f "${last_run_path}" ]
then
	lastRunDate=$(cat "${last_run_path}")
	dateafter=$(date --date "${lastRunDate} -1 days" +%Y%m%d)
else
	dateafter="19000101"	
fi

# dateafter=$(date -d "-30 days" +%Y%m%d)

# TODO remove colons
# remove "hours of" lines

# get the last 30 days of video titles from dungeon synth archives
# don't download the videos themselves
# yt-dlp "https://www.youtube.com/channel/UChmm356a5qe1luUsoatAgjA" --dateafter "${dateafter}" --skip-download --get-title 2>&1 | perl -pe 's/[\(\[\{].+?[\)\]\}]//g' | tac >> "${playlist_path}"

text=$(yt-dlp "https://www.youtube.com/channel/UChmm356a5qe1luUsoatAgjA" --dateafter "${dateafter}" --skip-download --get-title 2>&1)
echo "${text}" >> "${raw_log_path}"
# strip parenthetical phrases (videos never have nested parentheticals)
text=$(echo "${text}" | perl -pe 's/[\(\[\{].+?[\)\]\}]//g')
# dump colons
text=$(echo "${text}" | perl -pe 's/://g')
# trim leading/trailing white space while we're at it
text=$(echo "${text}" | perl -pe 's/^[^\S\r\n]+|[^\S\r\n]+$//g')
# remove non-album titles
text=$(echo "${text}" | grep -Piv '\d hours? of')
# remove error lines
# could just remove the 2>&1 above but it must be these for a reason
text=$(echo "${text}" | grep -Pv '^(ERROR|WARNING) {2}')

# reverse order so newest is at the bottom, append to playlist
echo "${text}" | tac >> "${playlist_path}"
date +%Y%m%d > "${last_run_path}"
