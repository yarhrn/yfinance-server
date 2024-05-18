# accept cli params for type of the release and describe if nothin is choosen
RELEASE_TYPE=$1
if [ -z "$RELEASE_TYPE" ]; then
  echo "Please provide release type: major, minor or patch"
  exit 1
fi

# check if release type is valid
if [ "$RELEASE_TYPE" != "major" ] && [ "$RELEASE_TYPE" != "minor" ] && [ "$RELEASE_TYPE" != "patch" ]; then
  echo "Invalid release type. Please provide major, minor or patch"
  exit 1
fi

# get last release version from last-release-verion.txt
LAST_VERSION=$(cat last-release-version.txt)

# increment version based on release type
if [ "$RELEASE_TYPE" == "major" ]; then
  IFS='.' read -r -a VERSION <<< "$LAST_VERSION"
  VERSION=$((VERSION[0] + 1)).0.0
elif [ "$RELEASE_TYPE" == "minor" ]; then
  IFS='.' read -r -a VERSION <<< "$LAST_VERSION"
  VERSION=${VERSION[0]}.$((VERSION[1] + 1)).0
elif [ "$RELEASE_TYPE" == "patch" ]; then
  IFS='.' read -r -a VERSION <<< "$LAST_VERSION"
  VERSION=${VERSION[0]}.${VERSION[1]}.$((VERSION[2] + 1))
fi

# confirm that you want to release version
read -p "Releasing version $VERSION - are you sure? (y/n) " -n 1 -r

# check if everything is commited in git repo
if [ -n "$(git status --porcelain)" ]; then
  echo "There are uncommited changes. Please commit or stash them before releasing."
  exit 1
fi



# read commit changes from last version to current version
# add two new lines to the end of the each line in the commit log
LOG=$(git log --pretty=format:"%h %s" $LAST_VERSION..HEAD)
LOG=$(echo "$LOG" | sed -e 's/$/  /g')
# read yfinance version from requirements.txt
YFINANCE_VERSION=$(grep yfinance requirements.txt | cut -d'=' -f2)

# add to the change log
# current version as a header
# version of yfinance
# all commit logs since last version
echo "## $VERSION" > tmpfile
echo "" >> tmpfile
echo "### Dependencies" >> tmpfile
echo "" >> tmpfile
echo "- yfinance: $YFINANCE_VERSION" >> tmpfile
echo "" >> tmpfile
echo "### Changes" >> tmpfile
echo "" >> tmpfile
echo "$LOG" >> tmpfile
echo "" >> tmpfile
echo "" >> tmpfile
cat CHANGELOG.MD >> tmpfile
mv tmpfile CHANGELOG.MD



# update and push changelog
git add CHANGELOG.MD
git commit -m "Update changelog for version $VERSION"

# create and commit tag with version name
git tag $VERSION
# update and push last-release-version.txt
echo $VERSION > last-release-version.txt
# update all occurence of last version in the README.md to the new version
sed -i "" "s/$LAST_VERSION/$VERSION/g" README.md
git add README.MD
git add last-release-version.txt
git commit -m "Update last release version to $VERSION"

git push origin $VERSION
git push origin main

docker buildx build --platform linux/amd64,linux/arm64 -t yarhrn/yfinance-server:$VERSION -t yarhrn/yfinance-server:latest --push .
