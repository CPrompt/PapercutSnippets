# Run this script from the server to bulk edit a specific property
# of all the users.
# This was needed to blank out the secondary-card-numbers field of 
# all users.  
# This can be expanded to alter the values or add values
# Can also be used to edit multiple properties

# This script will allow using specific usernames instead of a group or all users

# Change to the PaperCut server command directory
cd "C:\Program Files\PaperCut MF\server\bin\win"

# Define your specific users
$users = @(
    "username1",
    "username2",
    "username3",
    "username4",
    "username5",
    "username6"
)

# Clear the secondary card number for each user
foreach ($u in $users) {
    .\server-command set-user-property $u secondary-card-number `" `"
}