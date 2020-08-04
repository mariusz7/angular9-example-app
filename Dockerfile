#FROM nginx:1.19.1-alpine
FROM amazonlinux:2
RUN sudo yum update -y
RUN sudo yum install nginx -y
RUN sudo service nginx start
RUN sudo chkconfig nginx on
RUN ls -la /etc/
RUN ls -la /etc/nginx/ || true
COPY nginx.conf /etc/nginx/nginx.conf
COPY ./dist/browser /usr/share/nginx/html
