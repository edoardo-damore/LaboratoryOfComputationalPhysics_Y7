# !/bin/bash

# A

file_dir="./ex_files/03/"
file="$file_dir/data.txt"

if [ ! -f $file ]
then
    touch $file
fi

grep "^#" -v "$file_dir/data.csv" | sed "s/,//g"  > $file

# B

echo "$( sed -e "s/ /\n/g" $file | grep -c "\b[0-9]*[02468]\b" )"

# C

greater=0
smaller=0

threshold=$( echo "scale=3; 100 * sqrt(3) / 2" | bc )

while read -r line
do
    x1=$( echo $line | cut -f1 -d " " )
    y1=$( echo $line | cut -f2 -d " " )
    z1=$( echo $line | cut -f3 -d " " )
    d1=$( echo "scale=3;sqrt($x1^2 + $y1^2 + $z1^2)" | bc )
    
    if [ $( echo "$d1 < $threshold" | bc ) == "1" ]
    then
        smaller=$(( $smaller+1 ))
    else 
        greater=$(( $greater+1 ))
    fi
     
    x2=$( echo $line | cut -f4 -d " " )
    y2=$( echo $line | cut -f5 -d " " )
    z2=$( echo $line | cut -f6 -d " " )
    d2=$( echo "scale=3;sqrt($x2^2 + $y2^2 + $z2^2)" | bc )

    if [ $( echo "$d2 < $threshold" | bc ) == "1" ]
    then
        smaller=$(( $smaller+1 ))
    else 
        greater=$(( $greater+1 ))
    fi
done < "$file"

echo "Smaller than threshold $threshold: $smaller"
echo "Greater than threshold $threshold: $greater"

# D

for (( i=1; i<=$1; i++ ))
do
    if [ ! -f "$file_dir/d$i.txt" ]
    then
        touch "$file_dir/d$i.txt"
    fi
    echo > "$file_dir/d$i.txt"
    
    while read -r line
    do
        a=$( echo "scale=3; $( echo $line | cut -f1 -d " " ) / $i" | bc )
        b=$( echo "scale=3; $( echo $line | cut -f2 -d " " ) / $i" | bc )
        c=$( echo "scale=3; $( echo $line | cut -f3 -d " " ) / $i" | bc )
        d=$( echo "scale=3; $( echo $line | cut -f4 -d " " ) / $i" | bc )
        e=$( echo "scale=3; $( echo $line | cut -f5 -d " " ) / $i" | bc )
        f=$( echo "scale=3; $( echo $line | cut -f6 -d " " ) / $i" | bc )
        
        echo "$a $b $c $d $e $f" >> "$file_dir/d$i.txt"
    done < "$file"
done