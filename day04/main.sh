#!/usr/bin/bash

function first {
    
    valids=0

    while read line || [ -n "$line" ]
    do

        unique=$(echo "$line" | xargs -n1 | sort -u | xargs )

        if [ ${#unique} -eq ${#line} ];
        then
            valids=$((valids + 1))
        fi

    done < "$1"


    echo "Number of valid phrases: $valids"

}


# Basically the same as first part, but now sort the words to filter out anagrams
function second {
    
    valids=0

    while read line || [ -n "$line" ]
    do

        # Just split line to be able to loop over it easily
        splitted=$(echo "$line" | xargs -n1)

        # Sort each word in place with regards to characters, still keep words on different lines
        sorted=$(for word in $splitted; do echo "$word" | grep -o . | sort | tr -d '\n' | sed 's/$/\n/' ; done)

        # Now sort the lines (words), but only keep uniques
        unique=$(echo "$sorted" | sort -u)

        if [ ${#unique} -eq ${#sorted} ];
        then
            valids=$((valids + 1))
        fi

    done < "$1"


    echo "Number of valid phrases not counting anagrams: $valids"

}

# Ugly, but if you add another input it will run the first part and ignore anagrams
if [ $# -gt 1 ]; then
   first $1
else
   second $1
fi
