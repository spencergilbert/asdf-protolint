#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/yoheimuta/protolint"
TOOL_NAME="protolint"
TOOL_TEST="protolint --help"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//'
}

list_all_versions() {
	list_github_tags
}

get_platform() {
	if [[ $(uname -s) == "Darwin" ]]; then
		_plat="$(uname | tr '[:upper:]' '[:lower:]')"
		echo "$_plat"
	elif [[ $(uname -s) == "Linux" ]]; then
		_plat="$(uname | tr '[:upper:]' '[:lower:]')"
		echo "$_plat"
	else
		echo >&2 'Platform not supported' && exit 1
	fi
}

# from https://stackoverflow.com/questions/4023830/how-to-compare-two-strings-in-dot-separated-version-format-in-bash
vercomp() {
	if [[ $1 == $2 ]]; then
		return 0
	fi
	local IFS=.
	local i ver1=($1) ver2=($2)
	# fill empty fields in ver1 with zeros
	for ((i = ${#ver1[@]}; i < ${#ver2[@]}; i++)); do
		ver1[i]=0
	done
	for ((i = 0; i < ${#ver1[@]}; i++)); do
		if ((10#${ver1[i]:=0} > 10#${ver2[i]:=0})); then
			return 1
		fi
		if ((10#${ver1[i]} < 10#${ver2[i]})); then
			return 2
		fi
	done
	return 0
}

get_arch() {
	local version="$1"
	if [[ $(uname -m) == "x86_64" ]]; then
		vercomp $version "0.45.0"
		case $? in
		0) echo "x86_64" ;;
		1) echo "amd64" ;;
		2) echo "x86_64" ;;
		*) echo "amd64" ;;
		esac
	elif [[ $(uname -m) == "arm64" ]]; then
		echo "arm64"
	else
		echo >&2 'Architecture not supported' && exit 1
	fi
}

download_release() {
	local version filename url
	version="$1"
	filename="$2"
	platform="$3"
	arch="$4"

	url="$GH_REPO/releases/download/v${version}/${TOOL_NAME}_${version}_${platform}_${arch}.tar.gz"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="$3"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path/bin"
		cp "$ASDF_DOWNLOAD_PATH/$TOOL_NAME" "$install_path/bin"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error ocurred while installing $TOOL_NAME $version."
	)
}
