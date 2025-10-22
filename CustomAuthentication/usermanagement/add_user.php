<?php include 'config.php'; ?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add User</title>
</head>
<body>
    <h2>Add New User</h2>
    <form method="post">
        <label>Username: <input type="text" name="username" required></label><br>
        <label>Full Name: <input type="text" name="fullname" required></label><br>
        <label>Email: <input type="email" name="email"></label><br>
        <label>Department: <input type="text" name="department"></label><br>
        <label>Office: <input type="text" name="office"></label><br>
        <label>Card No: <input type="text" name="cardno"></label><br>
        <label>Secondary Card No: <input type="text" name="secondarycardno"></label><br>
        <label>Password: <input type="password" name="password" required></label><br><br>
        <button type="submit">Save</button>
        <a href="index.php">Cancel</a>
    </form>

<?php
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $password_hash = password_hash($_POST["password"], PASSWORD_BCRYPT);
    $stmt = $pdo->prepare("INSERT INTO users (username, fullname, email, dept, office, cardno, secondarycardno, password)
                           VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
    try {
        $stmt->execute([
            $_POST["username"],
            $_POST["fullname"],
            $_POST["email"],
            $_POST["department"],
            $_POST["office"],
            $_POST["cardno"],
            $_POST["secondarycardno"],
            $password_hash
        ]);
        echo "<p style='color:green;'>User added successfully. <a href='index.php'>Back to list</a></p>";
    } catch (PDOException $e) {
        echo "<p style='color:red;'>Error: " . $e->getMessage() . "</p>";
    }
}
?>
</body>
</html>
