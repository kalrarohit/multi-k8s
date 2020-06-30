# this script will build the images, tag them, push to docker, 
#apply configs and have imperative command to pick latest or version images

# Build Images (2 images are created one with latest version and other with $SHA which is the git commit version coming from travis config)
docker build -t rohitkalra/multi-client:latest -t rohitkalra/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t rohitkalra/multi-server:latest -t rohitkalra/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t rohitkalra/multi-worker:latest -t rohitkalra/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# Push Images, already logged via travis configs

docker push rohitkalra/multi-client:latest
docker push rohitkalra/multi-server:latest
docker push rohitkalra/multi-worker:latest

docker push rohitkalra/multi-client:$SHA
docker push rohitkalra/multi-server:$SHA
docker push rohitkalra/multi-worker:$SHA

#Apply configs via kubectl as kubectl is already configured in travis config

kubectl apply -f k8s

# Imperative command to update the image in the containers to the $SHA version which is the git commit version coming from travis config
kubectl set image deployments/client-deployment client=rohitkalra/multi-client:$SHA
kubectl set image deployments/server-deployment server=rohitkalra/multi-server:$SHA
kubectl set image deployments/worker-deployment worker=rohitkalra/multi-worker:$SHA

