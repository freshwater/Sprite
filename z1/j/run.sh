# docker build . -t t && docker run --interactive --tty t
docker build . -t t && docker run --mount type=bind,src="$(pwd)",dst=/workfolder --interactive --tty t
