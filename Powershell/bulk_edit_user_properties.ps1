# List of scripts that can be used to modify properies of given users
# users can be *all*, *specific users*, or a *specific group*
# This was needed to blank out the secondary-card-numbers field of 
# all users.  
# This can be expanded to alter the values or add values
# Can also be used to edit multiple properties



#----------------- Command 1 -------------------------------------#
# This command will do all users in the PaperCut instance
cd "C:\Program Files\PaperCut MF\server\bin\win"
$users = (.\server-command list-user-accounts)
foreach ($u in $users) {
    .\server-command set-user-property $u secondary-card-number " "
}


#----------------- Command 2 -------------------------------------#
# This will allow you to edit all users in a specific group

# Change to the PaperCut server command directory
cd "C:\Program Files\PaperCut MF\server\bin\win"

# Define the group name
$groupName = "YourGroupNameHere"

# Get all users in the group
$users = (.\server-command get-group-members $groupName)

# Clear the secondary card number for each user
foreach ($u in $users) {
    .\server-command set-user-property $u secondary-card-number " "
}


#----------------- Command 3 -------------------------------------#
# This will allow each user to be defined that you would like 
# to run the command against

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
    .\server-command set-user-property $u secondary-card-number " "
}