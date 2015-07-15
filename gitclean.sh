# This script is used to clean all git commit
# Refer to : http://stackoverflow.com/questions/13716658/how-to-delete-all-commit-history-in-github
git checkout --orphan latest_branch
git add -A
git commit -am "Delete all previous commit"
git branch -D master
git branch -m master
git push -f origin master
