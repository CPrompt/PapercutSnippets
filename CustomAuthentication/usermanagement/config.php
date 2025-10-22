<?php
$host = "localhost";
$dbname = "papercut_users";
$user = "papercut";
$pass = "password";

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $user, $pass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
	die("Database connection failed: " . $e->getMessage());
	echo "You're DEAD!";
}
?>
