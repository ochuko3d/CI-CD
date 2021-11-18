FROM ghost:3.40.2
RUN apt-get update -y && \
    apt-get install -y default-mysql-client
# Volumes are used for data persistency, so we can keep our data even when the image is removed or when we change the host machine 
VOLUME ["/var/www/ghost/content/apps"] 
VOLUME ["/var/www/ghost/content/data"] 
VOLUME ["/var/www/ghost/content/images"] 
COPY ./wait-for-it.sh /usr/local/bin/wait-for-it.sh
EXPOSE 2368