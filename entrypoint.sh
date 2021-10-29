#!/bin/sh

set -e
set -x

if [ -z "$INPUT_SOURCE_FOLDER" ]
then
  echo "Source folder must be defined"
  return -1
fi

if [ -z "$INPUT_DESTINATION_BRANCH" ]
then
  INPUT_DESTINATION_BRANCH=master
fi
OUTPUT_BRANCH="$INPUT_DESTINATION_BRANCH"

if [ -z "$INPUT_COMMIT_MSG" ]
then
  INPUT_COMMIT_MSG="Update $INPUT_DESTINATION_FOLDER."
fi

CLONE_DIR=$(mktemp -d)

echo "Cloning destination git repository"
git config --global user.email "$INPUT_USER_EMAIL"
git config --global user.name "$INPUT_USER_NAME"
git clone --single-branch --branch $INPUT_DESTINATION_BRANCH "https://$API_TOKEN_GITHUB@github.com/$INPUT_DESTINATION_REPO.git" "$CLONE_DIR"

if [ ! -z "$INPUT_DESTINATION_BRANCH_CREATE" ]
then
  git checkout -b "$INPUT_DESTINATION_BRANCH_CREATE"
  OUTPUT_BRANCH="$INPUT_DESTINATION_BRANCH_CREATE"
fi

if [[ "$INPUT_DESTINATION_PROJECT" == "hamster" ]]
then
  echo "Copying contents to git repo"
  mkdir -p $CLONE_DIR/$INPUT_DESTINATION_FOLDER/
  cp $INPUT_SOURCE_FOLDER/generated.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/generated.proto
  cp $INPUT_SOURCE_FOLDER/hamster-generated.pb $CLONE_DIR/$INPUT_DESTINATION_FOLDER/hamster-generated.pb
fi

if [[ "$INPUT_DESTINATION_PROJECT" == "helix2" ]]
then
  echo "Copying contents to git repo"
  mkdir -p $CLONE_DIR/$INPUT_DESTINATION_FOLDER/
  cp $INPUT_SOURCE_FOLDER/generated.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/generated.proto
  cp $INPUT_SOURCE_FOLDER/helix2-generated.pb $CLONE_DIR/$INPUT_DESTINATION_FOLDER/helix2-generated.pb
fi


cd "$CLONE_DIR"

echo "Adding git commit"
git add .
if git status | grep -q "Changes to be committed"
then
  git commit --message "$INPUT_COMMIT_MSG"
  echo "Pushing git commit"
  git push -u origin HEAD:$OUTPUT_BRANCH
else
  echo "No changes detected"
fi