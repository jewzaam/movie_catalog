#!/bin/sh

SEARCH=`echo $@ | tr ' ' '+'`

SEARCH_RESULT_FILENAME=.search.json
curl -s "http://www.omdbapi.com/?t=$SEARCH&y=&plot=short&r=json" > $SEARCH_RESULT_FILENAME
eval `cat .search.json |python -mjson.tool|grep '"'|sed 's/[ ]*"\([^"]*\)": \("[^"]*"\).*/\1=\2/g'`

#{
#    "Actors": "Nathan Fillion, Gina Torres, Alan Tudyk, Morena Baccarin",
#    "Awards": "9 wins & 8 nominations.",
#    "Country": "USA",
#    "Director": "Joss Whedon",
#    "Genre": "Action, Adventure, Sci-Fi",
#    "Language": "English, Mandarin",
#    "Metascore": "74",
#    "Plot": "The crew of the ship Serenity try to evade an assassin sent to recapture one of their numbers who is telepathic.",
#    "Poster": "https://images-na.ssl-images-amazon.com/images/M/MV5BMTI0NTY1MzY4NV5BMl5BanBnXkFtZTcwNTczODAzMQ@@._V1_SX300.jpg",
#    "Rated": "PG-13",
#    "Released": "30 Sep 2005",
#    "Response": "True",
#    "Runtime": "119 min",
#    "Title": "Serenity",
#    "Type": "movie",
#    "Writer": "Joss Whedon",
#    "Year": "2005",
#    "imdbID": "tt0379786",
#    "imdbRating": "8.0",
#    "imdbVotes": "246,357"
#}

if [ ${Response,,} == 'true' ];
then
    if [ -e .catalog/$imdbID ];
    then
        echo "Title '$Title', $Year, is already in the catalog."
    else
        echo "Found: $Title, $Year"
        echo "   Director: $Director"
		echo "   Actors: $Actors"
        echo "   Summary: $Plot"
        echo -n "Add to catalog? (Yn): "
        read -n 1 INPUT
		echo ""
        if [ ${INPUT,,} == "y" ];
        then
            mkdir -p .catalog/$imdbID
            mv $SEARCH_RESULT_FILENAME .catalog/$imdbID
        fi
    fi
else
    echo "Not found."
fi
