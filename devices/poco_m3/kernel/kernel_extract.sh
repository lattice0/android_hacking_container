rm -rf k
mkdir k
echo "extracting kernel at folder $PWD/k..."
bsdtar xf k.zip --strip-components=1 -C k