<?php
include "config.php";

if (!isset($_GET["id"])) die("Missing group ID.");
$id = intval($_GET["id"]);

$stmt = $pdo->prepare("DELETE FROM groups WHERE id=:id");
$stmt->execute(["id" => $id]);

header("Location: groups.php");
exit;
