# Run this script from the server to bulk edit a specific property
# of all the users.
# This was needed to blank out the secondary-card-numbers field of 
# all users.  
# This can be expanded to alter the values or add values
# Can also be used to edit multiple properties


cd "C:\Program Files\PaperCut MF\server\bin\win"
$users = (.\server-command list-user-accounts)
foreach ($u in $users) {
    .\server-command set-user-property $u secondary-card-number " "
}
