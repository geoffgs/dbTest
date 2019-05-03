FROM alpine:latest
MAINTAINER me
USER root
RUN apk -Uuvv add --no-cache bash curl tzdata ca-certificates git && \
	#git clone https://github.com/kellmant/cpapi.git /ctrl && \
	addgroup -g 2000 core && \
	adduser -D ctrl -u 2000 -g core -G core -s /bin/bash -h /ctrl && \
	adduser -D node -u 2001 -g core -G core -s /bin/bash -h /node && \
	mkdir -p /ctrl && \
	mkdir -p /node && chown ctrl.core /node && \
	update-ca-certificates && \
	mkdir -p /tmp/build && cd /tmp/build && \
	cd .. && rm -rf /tmp/build
COPY /.bash_profile /ctrl/.bash_profile
RUN apk -Uuvv add --no-cache autoconf automake cmake make nano g++ coreutils \ 
	jq openssl-dev findutils nodejs-npm nodejs-dev nodejs ncurses && \
	chown -R ctrl.core /ctrl 
#RUN apk -Uuvv add --no-cache 	
EXPOSE 7001 7002
USER ctrl
WORKDIR /ctrl 
ENV NPM_CONFIG_PREFIX=/node
RUN npm config set package-lock false && \
	npm install -g npm && \
	npm update -g && \
	npm install -g generate-schema jsdoc jsdiff-console jsdiff && \ 
	#npm install -g nodemon && \
	npm install ipaddr.js datetime natsort cidr-tools cidr-range cidr-regex && \
	npm install oracledb validator ip-utils ip-subnet-calculator datalib
#ENV NPM_CONFIG_PREFIX=/node
ENV PATH=~/bin:/node/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin ETCDCTL_STRICT_HOST_KEY_CHECKING=false TERM=screen-256color

#ENTRYPOINT ["/bin/tini", "-g", "--"]
ENTRYPOINT ["/bin/bash"]
CMD ["-l"]

