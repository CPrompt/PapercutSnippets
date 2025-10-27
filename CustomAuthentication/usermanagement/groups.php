<?php include "config.php"; ?>

<!DOCTYPE HTML>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Group Management</title>
<style>
table { border-collapse: collapse; width: 60%; margin: 20px auto; }
th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
th { background-color: #f4f4f4; }
a { text-decoration: none; margin: 0 5px; }
.add { display: block; text-align: center; margin: 20px; }
</style>
</head>
<body>
<h2 style="text-align:center;">Group Management</h2>
<a class="add" href="add_group.php">Add New Group</a>
<a class="add" href="index.php">Cancel</a>

<table>
<tr>
    <th>Group Name</th>
    <th>Actions</th>
</tr>

<?php
try {
    $stmt = $pdo->query("SELECT * FROM groups ORDER BY groupname");
    $groups = $stmt->fetchAll(PDO::FETCH_ASSOC);

    if (empty($groups)) {
        echo "<tr><td colspan='2' style='text-align:center;'>No groups found.</td></tr>";
    } else {
        foreach ($groups as $row) {
            echo "<tr>
                <td>{$row['groupname']}</td>
                <td>
                    <a href='edit_group.php?id={$row['id']}'>Edit</a> |
                    <a href='delete_group.php?id={$row['id']}' onclick=\"return confirm('Delete this group? Users in this group will be removed from it.');\">Delete</a>
                </td>
            </tr>";
        }
    }
} catch (PDOException $e) {
    echo "<tr><td colspan='2'>Query failed: {$e->getMessage()}</td></tr>";
}
?>
</table>
</body>
</html>
