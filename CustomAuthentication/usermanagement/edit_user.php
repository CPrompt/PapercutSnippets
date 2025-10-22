<?php include 'config.php';

if (!isset($_GET['id'])) {
    die("Missing user ID.");
}

$id = intval($_GET['id']);
$stmt = $pdo->prepare("SELECT * FROM users WHERE id=?");
$stmt->execute([$id]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$user) {
    die("User not found.");
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit User</title>
</head>
<body>
    <h2>Edit User: <?= htmlspecialchars($user['username']) ?></h2>
    <form method="post">
        <label>Full Name: <input type="text" name="fullname" value="<?= htmlspecialchars($user['fullname']) ?>" required></label><br>
        <label>Email: <input type="email" name="email" value="<?= htmlspecialchars($user['email']) ?>"></label><br>
        <label>Department: <input type="text" name="department" value="<?= htmlspecialchars($user['department']) ?>"></label><br>
        <label>Office: <input type="text" name="office" value="<?= htmlspecialchars($user['office']) ?>"></label><br>
        <label>Card No: <input type="text" name="cardno" value="<?= htmlspecialchars($user['cardno']) ?>"></label><br>
        <label>Secondary Card No: <input type="text" name="secondarycardno" value="<?= htmlspecialchars($user['secondarycardno']) ?>"></label><br>
        <label>New Password (leave blank to keep current): <input type="password" name="password"></label><br><br>
        <button type="submit">Save Changes</button>
        <a href="index.php">Cancel</a>
    </form>

<?php
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $password_hash = !empty($_POST["password"]) ? password_hash($_POST["password"], PASSWORD_BCRYPT) : $user["password_hash"];
    $stmt = $pdo->prepare("UPDATE users SET fullname=?, email=?, dept=?, office=?, cardno=?, secondarycardno=?, password=? WHERE id=?");
    $stmt->execute([
        $_POST["fullname"],
        $_POST["email"],
        $_POST["department"],
        $_POST["office"],
        $_POST["cardno"],
        $_POST["secondarycardno"],
        $password_hash,
        $id
    ]);
    echo "<p style='color:green;'>User updated. <a href='index.php'>Back to list</a></p>";
}
?>
</body>
</html>
