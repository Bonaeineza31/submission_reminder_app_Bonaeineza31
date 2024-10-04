 #!/bin/bash

mkdir -p submission_reminder_app/app
mkdir -p submission_reminder_app/modules
mkdir -p submission_reminder_app/assets
mkdir -p submission_reminder_app/config

echo "Directories are well  created!"

touch submission_reminder_app/app/reminder.sh
touch submission_reminder_app/modules/functions.sh
touch submission_reminder_app/assets/submissions.txt
touch submission_reminder_app/config/config.env
touch submission_reminder_app/startup.sh

echo "Files are also created!"

echo 'ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2' > submission_reminder_app/config/config.env

echo '#!/bin/bash

source ./config/config.env
source ./modules/functions.sh

submissions_file="./assets/submissions.txt"

echo "Assignment: $ASSIGNMENT"
                                                      
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file' > submission_reminder_app/app/reminder.sh


echo '#!/bin/bash

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
}' > submission_reminder_app/modules/functions.sh
echo '#!/bin/bash

cd "$(dirname  "$0")"
echo "Starting the Reminder App..."

bash ./app/reminder.sh

echo "Reminder App has been executed successfully!"' > submission_reminder_app/startup.sh

cat <<EOL >> submission_reminder_app/assets/submissions.txt
Student Name, Assignment, Status
Gitangaza Bernyce, Shell Navigation, not submitted
Bella Calmine, Shell Navigation, submitted
Bonae Ineza, Shell Navigation, not submitted
Dushime Benita, Shell Navigation, submitted
Duhoze Benoite, Shell Navigation, not submitted
EOL

echo "Submission  with new records!"

chmod +x submission_reminder_app/startup.sh
