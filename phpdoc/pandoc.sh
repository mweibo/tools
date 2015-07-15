brew install pandoc

# single user
mkdir $HOME/context
rsync -av rsync://contextgarden.net/minimals/setup/first-setup.sh .
sh ./first-setup.sh --modules=all --engine=luatex
