FROM node:10-buster AS build

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY . .
RUN npm run build


FROM nginx:1.14.0-alpine

LABEL org.opencontainers.image.authors="Priyanshi Sarad <itspriyanshisarad@gmail.com>"

RUN apk --no-cache add \
      python3 \
      py3-pip \
      bash && \
    pip3 install --no-cache-dir 'j2cli[yaml]'

RUN rm -rf /usr/share/nginx/html/*

COPY --from=build /app/dist/ /usr/share/nginx/html/

COPY nginx.conf.j2 /templates/
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
