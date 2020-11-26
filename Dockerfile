FROM alpine:latest AS alpine
ENV LANG C.UTF-8

COPY . /caelus

RUN apk update && apk add yarn && yarn global add hexo-cli \
  && cd /caelus/blog && yarn && hexo g \
  && cd /caelus/blog-en && yarn && hexo g

FROM nginx:alpine AS nginx
ENV LANG C.UTF-8

COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/conf.d /etc/nginx/conf.d

COPY --from=alpine /caelus/blog/public/ /data/site/blog.muxin.io/
COPY --from=alpine /caelus/blog-en/public/ /data/site/blog.muxin.io/en/
