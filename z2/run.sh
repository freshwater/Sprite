
# PORT=8$(date +%s | tail -c 4)
# docker build . -t t && echo ; open 'http://localhost:'$PORT ; echo && docker run --publish $PORT:8888 --mount type=bind,src="$(pwd)",dst=/workfolder t

docker build . -t t && docker run --mount type=bind,src="$(pwd)",dst=/workfolder t $1

