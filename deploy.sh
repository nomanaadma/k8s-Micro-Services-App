docker build -t nomanaadma/multi-client:latest -t nomanaadma/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t nomanaadma/multi-server:latest -t nomanaadma/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t nomanaadma/multi-worker:latest -t nomanaadma/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push nomanaadma/multi-client:latest
docker push nomanaadma/multi-server:latest
docker push nomanaadma/multi-worker:latest

docker push nomanaadma/multi-client:$SHA
docker push nomanaadma/multi-server:$SHA
docker push nomanaadma/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=nomanaadma/multi-server:$SHA
kubectl set image deployments/client-deployment client=nomanaadma/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=nomanaadma/multi-worker:$SHA