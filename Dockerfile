FROM nginx:1.19.1-alpine
COPY nginx.conf /etc/nginx/nginx.conf
COPY ./dist/browser /usr/share/nginx/html
