<?php
require 'config.php'; // PDO connection

// Get User ID from URL
$id = $_GET['id'] ?? null;
if (!$id) {
    die("No user ID provided.");
}

//  Fetch existing user data
$stmtUser = $pdo->prepare("SELECT * FROM users WHERE id = :id");
$stmtUser->execute(['id' => $id]);
$user = $stmtUser->fetch(PDO::FETCH_ASSOC);

if (!$user) {
    die("User not found.");
}

//  Fetch list of all groups
$stmtGroups = $pdo->query("SELECT id, groupname FROM groups ORDER BY groupname");
$groups = $stmtGroups->fetchAll(PDO::FETCH_ASSOC);

//  Fetch groups user currently belongs to
$stmtUserGroups = $pdo->prepare(
    "SELECT group_id FROM group_members WHERE user_id = :id"
);
$stmtUserGroups->execute(['id' => $id]);
$currentGroupIds = array_column($stmtUserGroups->fetchAll(PDO::FETCH_ASSOC), 'group_id');

//  If form submitted
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $newGroups = $_POST['groups'] ?? []; // Array of group IDs

    try {
        $pdo->beginTransaction();

        // Update user information (expand fields as needed)
        $stmtUpdate = $pdo->prepare(
            "UPDATE users SET username = :username, email = :email WHERE id = :id"
        );
        $stmtUpdate->execute([
            'username' => $_POST['username'],
            'email' => $_POST['email'],
            'id' => $id
        ]);

        //  Remove all existing group links
        $stmtDelete = $pdo->prepare("DELETE FROM group_members WHERE user_id = :id");
        $stmtDelete->execute(['id' => $id]);

        //  Add updated group membership rows
        if (!empty($newGroups)) {
            $stmtInsert = $pdo->prepare(
                "INSERT INTO group_members (user_id, group_id) VALUES (:user_id, :group_id)"
            );
            foreach ($newGroups as $groupId) {
                $stmtInsert->execute([
                    'user_id' => $id,
                    'group_id' => $groupId
                ]);
            }
        }

        $pdo->commit();
        echo "<p style='color: green'> User updated successfully!</p>";

        // Refresh current group list
        $currentGroupIds = $newGroups;

    } catch (Exception $e) {
        $pdo->rollBack();
        echo "<p style='color: red'>Error: " . $e->getMessage() . "</p>";
    }
}
?>

<h2>Edit User</h2>
<form method="POST">
	<label>Username:</label><br>
	<input type="text" name="username" value="<?= htmlspecialchars($user['username']); ?>" required><br><br>

	<label>Email:</label><br>
	<input type="email" name="email" value="<?= htmlspecialchars($user['email']); ?>" required><br><br>

	<label>Department:</label></br>
	<input type="text" name="dept" value="<?= htmlspecialchars($user['dept']); ?>" required><br><br>

	<label>Office:</label><br>
	<input type="text" name="office" value="<?= htmlspecialchars($user['office']); ?>"><br><br>

	<label>Card No:</label><br>
	<input type="text" name="cardno" value="<?= htmlspecialchars($user['cardno']); ?>"<br><br>

	<label>Secondary Number:</label><br>
	<input type="text" name="secondarycardno" value="<?= htmlspecialchars($user['secondarycardno']); ?>"<br><br>

	<label>New Password (leave blank to keep current password):</label><br>
	<input type="password" name="password" /><br><br>

	    <label>Groups:</label><br>
	    <select name="groups[]" multiple size="5" style="width:200px;">
        	<?php foreach ($groups as $group): ?>
		<option value="<?= $group['id']; ?>"
                	<?= in_array($group['id'], $currentGroupIds) ? 'selected' : '' ?>>
	                <?= htmlspecialchars($group['groupname']); ?>
        	</option>
	        <?php endforeach; ?>
	    </select><br><br>
  
	<button type="submit">Save Changes</button>
	<a href="index.php">Cancel</a>
</form>
