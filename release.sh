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



docker buildx build --platform linux/amd64 -t yarhrn/yfinance-server:$VERSION --push .
docker buildx build --platform linux/arm64 -t yarhrn/yfinance-server:$VERSION --push .

# read commit changes from last version to current version
LOG=$(git log --pretty=format:"%h %s" v$LAST_VERSION..HEAD)
# read yfinance version from requirements.txt
YFINANCE_VERSION=$(grep yfinance requirements.txt | cut -d'=' -f2)

# add current version including yfinance version section to changelog
awk -v v=$VERSION -v log="$LOG" -v yv=$YFINANCE_VERSION '/^## /{print "## " v " (" strftime("%Y-%m-%d") ")"; print ""; print "### yfinance version: " yv; print ""; print log; print ""; print $0; next}1' changelog.md > tmp
mv tmp changelog.md

# update and push changelog
git add changelog.md
git commit -m "Update changelog for version $VERSION"
git push

# create and commit tag with version name
git tag $VERSION
git push origin $VERSION

# update and push last-release-version.txt
echo $VERSION > last-release-version.txt
# update all occurence of last version in the README.md to the new version
sed -i "s/$LAST_VERSION/$VERSION/g" README.md
git add README.md
git add last-release-version.txt
git commit -m "Update last release version to $VERSION"
git push