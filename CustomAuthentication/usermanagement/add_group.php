<?php include "config.php"; ?>

<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $groupname = trim($_POST["groupname"]);

    if ($groupname !== "") {
        $stmt = $pdo->prepare("INSERT INTO groups (groupname) VALUES (:groupname)");
        $stmt->execute(['groupname' => $groupname]);
        header("Location: groups.php");
        exit;
    }
}
?>

<!DOCTYPE HTML>
<html lang="en">
<head><meta charset="UTF-8"><title>Add Group</title></head>
<body>
<h2 style="text-align:center;">Add Group</h2>
<form method="POST" style="width:300px;margin:20px auto;">
    <label>Group Name:</label><br>
    <input type="text" name="groupname" required><br><br>
    <input type="submit" value="Save">
</form>
<a href="groups.php" style="display:block;text-align:center;">Back</a>
</body>
</html>
