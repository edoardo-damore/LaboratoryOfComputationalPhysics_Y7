#!/bin/bash

# 2.a

dir="."
data_csv="data.csv"
data_txt="data.txt"

if [ ! -f "$dir/$data_txt" ]
then
  touch "$dir/$data_txt"
fi

# removing metadata
grep -v "^#" "$dir/$data_csv" > "$dir/$data_txt"
# removing commas
sed -i "s/,//g" "$dir/$data_txt"

# 2.b

# counts all numbers finishing with {0, 2, 4, 6, 8}
grep -c "\b[0-9]*[02468]\b" "$dir/$data_txt" 

# 2.c

threshold=$(echo "scale=4; 100 * sqrt(3) / 2" | bc -l)

# number of lines in the file
lines=$(wc -l < "$dir/$data_txt")

lower_counter=0
higher_counter=0

iter=1
while [ $iter -le $lines ]
do
  # selecting the iter-th line from the file
  l=$(awk "NR==$iter" "$dir/$data_txt")

  X1=$( echo "$l" | cut -f1 -d ' ')
  Y1=$( echo "$l" | cut -f2 -d ' ')
  Z1=$( echo "$l" | cut -f3 -d ' ')

  X2=$( echo "$l" | cut -f4 -d ' ')
  Y2=$( echo "$l" | cut -f5 -d ' ')
  Z2=$( echo "$l" | cut -f6 -d ' ')

  r1=$(echo "scale=4; sqrt($X1^2 + $Y1^2 + $Z1^2)" | bc -l)
  if (($(echo "$r1 < $threshold" | bc)))
  then
    lower_counter=$(($lower_counter + 1))
  else
    higher_counter=$(($higher_counter + 1))
  fi

  r2=$(echo "scale=4; sqrt($X2^2 + $Y2^2 + $Z2^2)" | bc -l)
  if (($(echo "$r2 < $threshold" | bc)))
  then
    lower_counter=$(($lower_counter + 1))
  else
    higher_counter=$(($higher_counter + 1))
  fi

  iter=$(($iter + 1))
done

echo "Lower than threshold counter: $lower_counter"
echo "Higher than threshold counter: $higher_counter"

# 2.d

# reading the first argument
n=$1

data_dir="data_dir"

if [ ! -d "$dir/$data_dir" ]
then
  mkdir "$dir/$data_dir"
fi

for f in `ls $dir/$data_dir`
do
  if [ -f "$dir/$data_dir/$f" ]
  then
    rm "$dir/$data_dir/$f"
  fi
done

for ((i=1;i<=$n;i++))
do
  ith_file="data_$i.txt"
  touch "$dir/$data_dir/$ith_file"

  lines=$(wc -l < "$dir/$data_txt")

  iter=1
  while [ $iter -le $lines ]
  do
    l=$(awk "NR==$iter" "$dir/$data_txt")

    x1=$( echo "$l" | cut -f1 -d ' ')
    x1=$( echo "scale=2; $x1/$i" | bc)    

    x2=$( echo "$l" | cut -f2 -d ' ')
    x2=$( echo "scale=2; $x2/$i" | bc)    

    x3=$( echo "$l" | cut -f3 -d ' ')
    x3=$( echo "scale=2; $x3/$i" | bc)    

    x4=$( echo "$l" | cut -f4 -d ' ')
    x4=$( echo "scale=2; $x4/$i" | bc)    

    x5=$( echo "$l" | cut -f5 -d ' ')
    x5=$( echo "scale=2; $x5/$i" | bc)    

    x6=$( echo "$l" | cut -f6 -d ' ')
    x6=$( echo "scale=2; $x6/$i" | bc)    

    echo "$x1 $x2 $x3 $x4 $x5 $x6" >> "$dir/$data_dir/$ith_file"

    iter=$(($iter + 1))
  done
done
