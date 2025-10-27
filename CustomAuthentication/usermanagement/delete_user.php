<?php
include 'config.php';

if (!isset($_GET['id'])) {
    die("Missing user ID.");
}

$id = intval($_GET['id']);

$stmt = $pdo->prepare("DELETE FROM users WHERE id=?");
$stmt->execute([$id]);

header("Location: index.php");
exit;
?>
