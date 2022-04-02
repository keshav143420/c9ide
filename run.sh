docker run --privileged \
  -e "IP=127.0.0.1" \
  -e "PORT=8080" \
  --mount type=bind,source=/home/keshav143420/c9ide,target=/home/ubuntu/workspace/ \
  -d -t -p 5050:5050 \
  -p 9090-9092:8080-8082 cloud9/ws-nodejs:latest