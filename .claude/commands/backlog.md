Add an idea to the project backlog.

Usage: /backlog <idea>

1. The idea is: $ARGUMENTS
2. Read `BACKLOG.md` in the current working directory if it exists
3. If `BACKLOG.md` does not exist, create it with this header:
   ```
   # Backlog
   ```
4. Append the idea as a new unchecked item under a `## Ideas` section (create the section if missing):
   ```
   - [ ] <idea>
   ```
5. Write the updated file. Do not commit. Confirm with a one-liner what was added.
