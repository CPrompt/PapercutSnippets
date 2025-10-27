<?php include "config.php";

if (!isset($_GET['id'])) die("Missing group ID.");
$id = intval($_GET['id']);

$stmt = $pdo->prepare("SELECT * FROM groups WHERE id=:id");
$stmt->execute(['id' => $id]);
$group = $stmt->fetch(PDO::FETCH_ASSOC);
if (!$group) die("Group not found.");

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $newname = trim($_POST["groupname"]);
    if ($newname !== "") {
        $stmt = $pdo->prepare("UPDATE groups SET groupname=:gn WHERE id=:id");
        $stmt->execute(['gn' => $newname, 'id' => $id]);
        header("Location: groups.php");
        exit;
    }
}
?>

<!DOCTYPE HTML>
<html lang="en">
<head><meta charset="UTF-8"><title>Edit Group</title></head>
<body>
<h2 style="text-align:center;">Edit Group</h2>

<form method="POST" style="width:300px;margin:20px auto;">
    <label>Group Name:</label><br>
    <input type="text" name="groupname" value="<?= htmlspecialchars($group['groupname']) ?>" required><br><br>
    <input type="submit" value="Update">
</form>

<a href="groups.php" style="display:block;text-align:center;">Back</a>
</body>
</html>
