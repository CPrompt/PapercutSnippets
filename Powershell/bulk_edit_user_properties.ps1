cd "C:\Program Files\PaperCut MF\server\bin\win"
$users = (.\server-command list-user-accounts)
foreach ($u in $users) {
    .\server-command set-user-property $u secondary-card-number " "
}