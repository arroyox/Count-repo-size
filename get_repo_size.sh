#!/bin/bash

# Function to fetch repository size
get_repo_size() {
  local repo_owner=$1
  local repo_name=$2
  local repo_version=$3

  # GitHub API URL for repository details
  local api_url="https://api.github.com/repos/${repo_owner}/${repo_name}"

  # Fetch repository details from GitHub API
  local response=$(curl -s $api_url)

  # Extract repository size from the JSON response
  local repo_size=$(echo $response | jq '.size')

  if [[ $repo_size != "null" ]]; then
    local repo_size_mb=$(echo "scale=2; $repo_size / 1024" | bc)
    echo "The size of the repository ${repo_owner}/${repo_name} is approximately ${repo_size_mb} MB."
  else
    echo "Error: Unable to fetch the repository size. Please check the repository owner and name."
  fi

  # Check if the specified version exists
  local version_url="https://api.github.com/repos/${repo_owner}/${repo_name}/git/refs/tags/${repo_version}"
  local version_response=$(curl -s $version_url)
  local version_sha=$(echo $version_response | jq -r '.object.sha')

  if [[ $version_sha != "null" ]]; then
    echo "The specified version ${repo_version} exists in the repository."
  else
    echo "Error: The specified version ${repo_version} does not exist in the repository."
  fi
}

# Check if the correct number of arguments is provided
if [[ $# -ne 3 ]]; then
  echo "Usage: $0 <repo_owner> <repo_name> <repo_version>"
  exit 1
fi

# Call the function with provided arguments
get_repo_size $1 $2 $3

