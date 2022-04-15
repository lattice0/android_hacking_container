#docker build -t aos .
docker build --build-arg userid=$(id -u) --build-arg groupid=$(id -g) --build-arg username=$(id -un) -t aos - < Dockerfile
