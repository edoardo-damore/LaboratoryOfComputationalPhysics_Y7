# !/bin/bash

# A

students_dir="$HOME/students1"
file_name="LCP_22-23_students.csv"
download_link="https://www.dropbox.com/scl/fi/bxv17nrbrl83vw6qrkiu9/LCP_22-23_students.csv?rlkey=47fakvatrtif3q3qw4q97p5b7&e=1"

if [ ! -d $students_dir ]
then
    mkdir $students_dir
    echo "Created the directory $students_dir"
else
    echo "Directory $students_dir alredy existed"
fi

if [ ! -f "$students_dir/$file_name" ]
then
    wget -O $file_name $download_link -nv
    grep -v "^Family name(s)" $file_name > "$students_dir/$file_name"
else
    echo "File $students_dir/$file_name already existed"
fi

# B

pod_students_file_name="pod_students.csv"
physics_students_file_name="physics_students.csv"

if [ ! -f "$students_dir/$pod_students_file_name" ]
then
    touch "$students_dir/$pod_students_file_name"
else
    echo "File $students_dir/$pod_students_file_name already existed"
fi

if [ ! -f "$students_dir/$physics_students_file_name" ]
then
    touch "$students_dir/$physics_students_file_name"
else
    echo "File $students_dir/$physics_students_file_name already existed"
fi

grep "PoD" $students_dir/$file_name > $students_dir/$pod_students_file_name
grep "Physics" $students_dir/$file_name > $students_dir/$physics_students_file_name 

# C & D

letter_with_max_counts="A"
max_counts=0

for letter in {A..Z}
do
    counts=$(grep -c "^$letter" "$students_dir/$file_name")
    echo "$letter: $counts"
    if [ $counts -gt $max_counts ]
    then
        max_counts=$counts
        letter_with_max_counts=$letter
    fi
done

echo "The letter with the most counts is $letter_with_max_counts: $max_counts"

# E

modulo=18
file_with_numbered_lines=$(grep "" --line-number "$students_dir/$file_name")


for (( i=0; i<$modulo; i++ ))
do
    if [ ! -f "$students_dir/s$i.csv" ]
    then 
        touch "$students_dir/s$i.csv"
    fi
    echo  > "$students_dir/s$i.csv"

    line_counter=1
    cat "$students_dir/$file_name" | while read line
    do
        # echo $line
        if [ $(( $line_counter % $modulo )) == $i ]
        then
            echo $line >> "$students_dir/s$i.csv"
        fi
        line_counter=$(( $line_counter + 1 ))
    done
done
