<?php include "config.php"; ?>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Management</title>
    <style>
        table { border-collapse: collapse; width: 80%; margin: 20px auto; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
        th { background-color: #f4f4f4; }
        a { text-decoration: none; margin: 0 5px; }
        .add { display: block; text-align: center; margin: 20px; }
    </style>
</head>
<body>
    <h2 style="text-align:center;">User Management</h2>
    <a class="add" href="add_user.php">Add New User</a>
    <table>
        <tr>
            <th>Username</th>
            <th>Full Name</th>
            <th>Email</th>
            <th>Department</th>
            <th>Office</th>
            <th>Actions</th>
	</tr>

<?php
        $stmt = $pdo->query("SELECT * FROM users");
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            echo "<tr>
                    <td>{$row['username']}</td>
                    <td>{$row['fullname']}</td>
                    <td>{$row['email']}</td>
                    <td>{$row['dept']}</td>
                    <td>{$row['office']}</td>
                    <td>
                        <a href='edit_user.php?id={$row['id']}'> Edit</a>
                        <a href='delete_user.php?id={$row['id']}' onclick=\"return confirm('Delete {$row['username']}?');\">Delete</a>
                    </td>
                  </tr>";
        }
        ?>
    </table>
</body>
</html>
