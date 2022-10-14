#!/bin/bash

#Variables
answer_no=no
answer_yes=yes
date=$(date)

# Hello thank you for visiting our resturant. Do you have time to complete a quick survey? Please enter "Yes" or "No".

echo "Hello do you have time to complete a survey? Please enter yes or no"

#input from command line from the user

read answer

# if statments based on the above input

if [ "$answer" == "$answer_yes" ]; 
  then  
      echo "Please rate your experience 1-5, with 5 being great and 1 being poor"
  elif [ "$answer" == "$answer_no" ];
    then
      echo "No worries, have a great day!"
      exit 
  else [ "$answer" != "$answer_yes" ] || [ "$answer" != "$answer_no" ]; 
      echo "Please type 'yes' or 'no' as a response."
      exit 
fi


# reading input for rating score
read rating

# conditional if statement for above input
if [ "$rating" -le 5 ] && [ "$rating" -ge 1 ];
  then
      echo "Thank you. You have completed this survey on $date. Have a great day!"
  elif [ "$rating" -lt 1 ] || [ "$rating" -gt 5 ] 
    then
      echo "This rating is not between 1-5"
      exit
fi

