#FROM nginx:1.19.1-alpine
FROM amazonlinux:2
#RUN yum update -y
#RUN yum install nginx -y
#RUN service nginx start
#RUN chkconfig nginx on
RUN amazon-linux-extras list | grep nginx
RUN amazon-linux-extras install nginx1.12
RUN ls -la /etc/
RUN ls -la /etc/nginx/ || true
COPY nginx.conf /etc/nginx/nginx.conf
COPY ./dist/browser /usr/share/nginx/html
