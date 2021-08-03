git clone https://github.com/gissarsky/exadel_devops.git
git config --global user.email "gemil@mail.ru"
git config --global user.name "Emil Garipov"
mkdir Task1
touch README.md
git add *
git commit -m "Readme file"
git push origin master
git checkout -b dev
echo 'Hello, Exadel!' > dev_branch.md
git checkout -b gissarsky-new_feature
echo 'New Feature' > README.md
echo '.' > .gitignore
git push --set-upstream origin gissarsky-new_feature
echo 'This is dev branch' > dev.md
git push --set-upstream origin dev
git revert d07deed7817
git log
touch log.txt
git branch -D gissarsky-new_feature
touch git_commands.md

