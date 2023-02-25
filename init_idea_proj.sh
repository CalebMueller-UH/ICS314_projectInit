#!/usr/bin/env bash

# Define the name and path of the script file
THIS_SCRIPT="./init_idea_proj.sh"

# Path to the project_initializer directory containing the config file and the template folder
PROJ_INIT_DIR="path/to/proj_init_dir"

# Check if PROJ_INIT_DIR is a valid directory and contains the required files
while true; do
  if [ ! -d "$PROJ_INIT_DIR" ]; then
    echo "Error: PROJ_INIT_DIR is not a valid directory."
  elif [ ! -f "$PROJ_INIT_DIR/project_initializer.config" ]; then
    echo "Error: project_initializer.config file not found in $PROJ_INIT_DIR."
  elif [ ! -d "$PROJ_INIT_DIR/template_files" ]; then
    echo "Error: template_files directory not found in PROJ_INIT_DIR."
  else
    # Convert PROJ_INIT_DIR to an absolute path
    PROJ_INIT_DIR=$(readlink -f "$PROJ_INIT_DIR")
    # Modify the PROJ_INIT_DIR value in the script file using sed
    sed -i "s|PROJ_INIT_DIR=\".*\"|PROJ_INIT_DIR=\"$PROJ_INIT_DIR\"|" $THIS_SCRIPT
    break
  fi
  read -p "Please enter a valid path to the project_initializer directory containing the config file and the template folder: " PROJ_INIT_DIR
done

# Load the config file
source "$PROJ_INIT_DIR/project_initializer.config"

# Define the path to the template files
TEMPLATE_FILES_DIR="$PROJ_INIT_DIR/template_files"

# Define the repository name to be initialized
DEST_DIR=$1

# Check if gh is installed
if ! command -v gh &>/dev/null; then
  echo "gh not found, installing using pip..."
  pip install gh
fi

# Check if the user is logged into gh
if ! gh auth status; then
  echo "You are not logged into gh. Please log in to proceed."
  gh auth login
fi

# Show the usage statement for invalid numbers of arguments or invalid argument combinations
show_usage_statement() {
  echo "Usage: ${THIS_SCRIPT} <destination_directory> [project_description or repository_link.git]"
  echo "  <destination_directory> : name of the local directory to create for the project."
  echo "  [project_description or repository_link.git] : optional project description or remote repository link."
  exit 1
}

# Check the number of arguments
if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  show_usage_statement
fi

# Define a function to add the template files
add_template_files() {
  find "$TEMPLATE_FILES_DIR" -mindepth 1 -maxdepth 1 -type f -exec cp {} "$DEST_DIR" \;
}

# Define a function to initialize the local repository
init_local_repo() {
  if [ -d "$DEST_DIR" ]; then
    read -p "There already exists a $DEST_DIR directory. Do you want to overwrite it? (yes/no) " ANSWER
    if [ "$ANSWER" == "yes" ] || [ "$ANSWER" == "Yes" ]; then
      # User wants to overwrite
      # Clean up the old repository
      gh repo delete $DEST_DIR
      rm -rf "$DEST_DIR"

      git init "$DEST_DIR"
    else
      # User doesn't want to overwrite
      read -p "Enter a different name for the repository: " DEST_DIR
      if [ "$DEST_DIR" == "" ]; then
        exit
      fi
      init_local_repo $DEST_DIR
    fi
  else
    # Destination directory does not already exist
    git init "$DEST_DIR"

  fi
  # Copy the template files from TEMPLATE_FILES_DIR
  add_template_files

  # Set up npm tools
  cd "$DEST_DIR"
  npm install

  # Create the initial commit
  git add .
  git commit -m "$DEST_DIR project initialized by script"

} # End of initLocalRepo()

#Define a function to add a collaborator
add_collab() {
  read -p "Would you like to add $COLLABORATOR_NAME as a collaborator? (y/n) " ANSWER
  if [ "$ANSWER" == "y" ] || [ "$ANSWER" == "" ]; then
    export GITHUB_TOKEN=$(gh auth token)
    DIR_NAME=$(basename $(pwd))
    gh api -X PUT -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github+json" "https://api.github.com/repos/$SELF_GITHUB_USER_NAME/$DIR_NAME/collaborators/$COLLABORATOR_GITHUB_USER_NAME"
    unset GITHUB_TOKEN
  fi
}

# Define a function to connect to a remote repository
connect_to_remote() {
  REPO_ADDRESS=$1
  git remote add origin $REPO_ADDRESS
  git push -u origin master
  add_collab
}

# Define a function to create a remote repository
create_remote_repo() {
  gh repo create "$1" --private
  THIS_REPO_ADDRESS="git@github.com:$SELF_GITHUB_USER_NAME/$1.git"
  connect_to_remote $THIS_REPO_ADDRESS
}

# Determine the number of arguments and execute the appropriate actions
case "$#" in
"1")
  init_local_repo $DEST_DIR
  create_remote_repo $DEST_DIR
  echo "done!"
  ;;

"2")
  # Number of arguments is 2
  if [[ $2 == *.git ]]; then
    # Second argument ends in ".git" indicating a repository link was given
    REPO_LINK=$2
    init_local_repo "$DEST_DIR"
    connect_to_remote "$2"
  else
    # Second argument doesn't end in ".git" and is interpreted as a project description
    PROJECT_DESC=$2
    init_local_repo "$DEST_DIR"
    create_remote_repo $DEST_DIR
    # Set the repository description
    gh api -X PATCH "/repos/$SELF_GITHUB_USER_NAME/$DEST_DIR" -F description="$PROJECT_DESC"
  fi
  ;;

"3")
  # Number of arguments is 3
  if [[ $2 == *.git ]]; then
    # Second argument ends in ".git" indicating a repository link was given
    REPO_LINK=$2
    init_local_repo "$DEST_DIR"
    connect_to_remote "$2"
    PROJECT_DESC=$3
    # Set the repository description
    gh api -X PATCH "/repos/$SELF_GITHUB_USER_NAME/$DEST_DIR" -F description="$PROJECT_DESC"
  else
    # Second argument doesn't end in ".git" and this is an invalid 3 argument call
    show_usage_statement
  fi
  ;;

*)
  show_usage_statement
  ;;
esac

echo "done!"
