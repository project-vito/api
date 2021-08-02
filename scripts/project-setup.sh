REPO_ID=378717776
USER_ID=$1
FOLDER_NAME="project-vito"


get_latest_release_url() {
  curl -u "$USER_ID" -o - "https://api.github.com/repositories/$1/tags" | jq -r '.[0].zipball_url';
}

get_latest_release_version() {
  curl -u "$USER_ID" -o - "https://api.github.com/repositories/$1/tags" | jq -r '.[0].name';
}

snapshot=$( get_latest_release_url "$REPO_ID" )
version=$( get_latest_release_version "$REPO_ID" )

echo "Last version found: $version"

wget "$snapshot"
unzip "$version"

rm "$version"

WEBAPP_FOLDER=$((find . -type d | grep project) | head -n 1)
cd $((find . -type d | grep project) | head -n 1)
yarn && yarn build

mv build ../build
cd ..
rm -fr "$WEBAPP_FOLDER"

