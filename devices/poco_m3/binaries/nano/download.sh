set -ex
rm -rf nano
mkdir -p nano
wget -O nano.tar.xz https://www.nano-editor.org/dist/v6/nano-6.3.tar.xz 
tar -xf nano.tar.xz --strip-components 1 -C nano