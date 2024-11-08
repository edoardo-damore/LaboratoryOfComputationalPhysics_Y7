#!/bin/bash

# 1.a

students_dir="$HOME/students"

if [ ! -d "$students_dir" ]
then 
  mkdir "$students_dir"
fi

file_name="LCP_22-23_students.csv"

if [ ! -f "$students_dir/$file_name" ]
then
  wget -O "$file_name" "https://www.dropbox.com/scl/fi/bxv17nrbrl83vw6qrkiu9/LCP_22-23_students.csv?rlkey=47fakvatrtif3q3qw4q97p5b7&e=1"
  cp "./$file_name" "$students_dir/$file_name"
  sed -i "1d" "$students_dir/$file_name"
fi


# 1.b

pod_students="pod_students"
phy_students="phy_students"

if [ ! -f "$students_dir/$pod_students" ]
then
  touch "$students_dir/$pod_students"
  grep "PoD" "$students_dir/$file_name" > "$students_dir/$pod_students"
fi

if [ ! -f "$students_dir/$phy_students" ]
then
  touch "$students_dir/$phy_students"
  grep "Physics" "$students_dir/$file_name" > "$students_dir/$phy_students"
fi

# 1.c

count_file="count.csv"
if [ ! -f "$students_dir/$count_file" ]
then
  touch "$students_dir/$count_file"
fi

echo "#Letter,Count" > "$students_dir/$count_file"
for l in {A..Z}
do
  echo "$l,$(grep -c "^$l" "$students_dir/$file_name")" >> "$students_dir/$count_file"
done


# 1.d

max_count=0
max_letter="A"

for l in {A..Z}
do
  temp_count=$(grep "^$l" "$students_dir/$count_file" | cut -f2 -s -d",")
  if [ $max_count -lt $temp_count ]
  then
    max_count=$temp_count
    max_letter=$l
  fi
done

echo "$max_letter appears $max_count times"

# 1.e

modulo=18
modulo_files="modulo"

for ((i=0; i<$(($modulo)); i++))
do
  rm -f "$students_dir/$modulo_files$i.csv"
done

for ((i=1; i<$(($modulo)); i++))
do
  touch "$students_dir/$modulo_files$i.csv"
done


lines=$(wc -l < "$students_dir/$file_name")

iter=1
while [ $iter -le $(($lines + 1)) ]
do
  mod=$(($iter%$modulo))

  # selecting the iter-th line and appending it to the mod-th file
  echo "$(awk "NR==$iter" "$students_dir/$file_name")" >> "$students_dir/$modulo_files$mod.csv"

  iter=$(($iter + 1))  
done
