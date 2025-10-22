#!/usr/bin/python3

"""
PaperCut Custom User Sync + Authentication Script
Modified to pull users and groups from MariaDB (instead of hard-coded data).
"""

import sys
from sys import exit, stdin, stdout, stderr
import logging
import xmlrpc.client
from ssl import create_default_context, Purpose
import mysql.connector
import bcrypt

# ---------------------- CONFIGURATION ----------------------
DB_HOST = "localhost"
DB_USER = "papercut"
DB_PASS = "password"
DB_NAME = "papercut_users"

auth = "token_pass"
host = "http://127.0.0.1:9191/rpc/api/xmlrpc"

# -----------------------------------------------------------

def get_connection():
    """Establish MariaDB connection."""
    return mysql.connector.connect(
        host=DB_HOST,
        user=DB_USER,
        password=DB_PASS,
        database=DB_NAME
    )

# ---------------------- DATABASE HELPERS ----------------------

def get_user(username):
    """Fetch a single user's record by username."""
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM users WHERE username = %s", (username,))
    user = cursor.fetchone()
    conn.close()
    return user

def get_all_users():
    """Return all users from the database."""
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM users")
    users = cursor.fetchall()
    conn.close()
    return users

def get_all_groups():
    """Return all groups from the database."""
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT groupname FROM groups")
    groups = [row[0] for row in cursor.fetchall()]
    conn.close()
    return groups

def get_group_members(groupname):
    """Return all users belonging to a given group."""
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT u.* FROM users u
        JOIN group_members gm ON gm.username = u.username
        WHERE gm.groupname = %s
    """, (groupname,))
    members = cursor.fetchall()
    conn.close()
    return members

def is_user_in_group(username, groupname):
    """Check if a user is in a specific group."""
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("""
        SELECT 1 FROM group_members
        WHERE username = %s AND groupname = %s
    """, (username, groupname))
    result = cursor.fetchone()
    conn.close()
    return result is not None

# ---------------------- USER DETAIL FORMATTER ----------------------

def format_user_details(user):
    """Format user data for PaperCut (short or long form)."""
    if not user:
        return None

    if extraData:
        return '\t'.join([
            user["username"], user["fullname"], user["email"],
            user["dept"], user["office"], user["cardno"],
            user["otherEmails"], user["secondarycardno"]
        ])
    else:
        return '\t'.join([
            user["username"], user["fullname"], user["email"],
            user["dept"], user["office"]
        ])

# ---------------------- PAPERCUT CONFIG CHECK ----------------------

try:
    proxy = xmlrpc.client.ServerProxy(host, verbose=False,
                context=create_default_context(Purpose.CLIENT_AUTH))
    extraData = True if "N" != proxy.api.getConfigValue(auth, "user-source.update-user-details-card-id") else False
except Exception:
    stderr.write("Cannot use web services API. Please configure properly.\n")
    exit(-1)

# ---------------------- MAIN SCRIPT LOGIC ----------------------

# User authentication call
if len(sys.argv) == 1:
    name = stdin.readline().strip()
    password = stdin.readline().strip()
    user = get_user(name)

    if user and bcrypt.checkpw(password.encode('utf-8'),user["password"].encode('utf-8')):
        stdout.write(f"OK\n{name}\n")
        exit(0)
    else:
        stderr.write("Wrong username or password\n")
        stdout.write("ERROR\n")
        exit(-1)

# Argument validation
if len(sys.argv) < 2 or sys.argv[1] != '-':
    stderr.write(f'Incorrect argument passed: {sys.argv}\n')
    sys.exit(-1)

# ---------------------- SYNC COMMANDS ----------------------

if sys.argv[2] == "is-valid":
    stdout.write(f'Y\n{"Long form user data record will be provided" if extraData else "Short form user data record will be provided"}\n')
    exit(0)

if sys.argv[2] == "all-users":
    for user in get_all_users():
        line = format_user_details(user)
        if line:
            stdout.write(line + "\n")
    exit(0)

if sys.argv[2] == "all-groups":
    print('\n'.join(get_all_groups()))
    exit(0)

if sys.argv[2] == "get-user-details":
    name = input().strip()
    user = get_user(name)
    if user:
        print(format_user_details(user))
        sys.exit(0)
    else:
        print(f"Can't find user {name}", file=sys.stderr)
        sys.exit(-1)

if sys.argv[2] == "group-member-names":
    groupname = sys.argv[3]
    members = get_group_members(groupname)
    if members:
        for user in members:
            print(user["username"])
        sys.exit(0)
    else:
        print(f"Group name {groupname} not found or has no members", file=sys.stderr)
        sys.exit(-1)

if sys.argv[2] == "group-members":
    groupname = sys.argv[3]
    members = get_group_members(groupname)
    if members:
        for user in members:
            line = format_user_details(user)
            if line:
                print(line)
        sys.exit(0)
    else:
        print(f"Group name {groupname} not found", file=sys.stderr)
        sys.exit(-1)

if sys.argv[2] == "is-user-in-group":
    groupname = sys.argv[3]
    username = sys.argv[4]
    if is_user_in_group(username, groupname):
        print('Y')
    else:
        print('N')
    sys.exit(0)

print(f"Can't process arguments {sys.argv}", file=sys.stderr)
sys.exit(-1)
