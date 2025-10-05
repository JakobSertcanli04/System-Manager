# System-Manager
This is a Bash system management script created. It provides a text-based menu interface for root users to manage system resources, including:

Computer information (ci) – displays hostname, OS, kernel, CPU, memory, disk space, and IP address.
User management (ua, ul, uv, um, ud) – add, list, view, modify, and delete users.
Group management (ga, gl, gv, gm, gd) – add, list, view, modify, and delete groups.
Folder management (fa, fl, fv, fm, fd) – create, list, view properties, modify permissions/ownership, and delete directories.

The script uses loops, case statements, and built-in Linux commands (useradd, usermod, groupadd, chmod, chown, ls, etc.) to handle operations. It ensures input validation (no special characters for usernames/groups) and provides interactive prompts for confirmation and navigation. Only the root user can execute it.
