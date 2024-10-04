#!/bin/bash

function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"
    
    declare -A reminded_students  # Create an associative array

    while IFS=, read -r student assignment status; do
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if the assignment is not submitted and if the student has already been reminded
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            if [[ -z "${reminded_students[$student]}" ]]; then  # Check if not reminded
                echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
                reminded_students[$student]=1  # Mark this student as reminded
            fi
        fi
    done < <(tail -n +2 "$submissions_file") 
}
