<?php include "config.php"; ?>

<!DOCTYPE HTML>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Management</title>
    <style>
        table { border-collapse: collapse; width: 90%; margin: 20px auto; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
        th { background-color: #f4f4f4; }
        a { text-decoration: none; margin: 0 5px; }
        .add { display: block; text-align: center; margin: 20px; }
    </style>
</head>
<body>
    <h2 style="text-align:center;">User Management</h2>
    <a class="add" href="add_user.php">Add New User</a>
    <a class="add" href="groups.php">Add Group</a>
    <table>
        <tr>
            <th>Username</th>
            <th>Full Name</th>
            <th>Email</th>
            <th>Department</th>
            <th>Office</th>
            <th>Groups</th>
            <th>Actions</th>
        </tr>

<?php
//  Updated SQL: fetch user + groups in one result set
$sql = "
    SELECT 
        u.id,
        u.username,
        u.fullname,
        u.email,
        u.dept,
        u.office,
        GROUP_CONCAT(g.groupname SEPARATOR ', ') AS groups
    FROM users u
    LEFT JOIN group_members gm ON u.id = gm.user_id
    LEFT JOIN groups g ON gm.group_id = g.id
    GROUP BY u.id
    ORDER BY u.username
";

try {
    $stmt = $pdo->query($sql);
    $users = $stmt->fetchAll(PDO::FETCH_ASSOC);

    if (empty($users)) {
        echo "<tr><td colspan='7' style='text-align:center;'>No users found.</td></tr>";
    } else {
        foreach ($users as $row) {
            echo "<tr>
                <td>{$row['username']}</td>
                <td>{$row['fullname']}</td>
                <td>{$row['email']}</td>
                <td>{$row['dept']}</td>
                <td>{$row['office']}</td>
                <td>" . ($row['groups'] ?: "None") . "</td>
                <td>
                    <a href='edit_user.php?id={$row['id']}'>Edit</a> |
                    <a href='delete_user.php?id={$row['id']}' onclick=\"return confirm('Delete this user?')\">Delete</a>
                </td>
            </tr>";
        }
    }
} catch (PDOException $e) {
    echo "<tr><td colspan='7'>Query failed: " . $e->getMessage() . "</td></tr>";
}
?>
    </table>
</body>
</html>
