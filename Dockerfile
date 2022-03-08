# Build environment.
FROM node:10-buster as builder
RUN mkdir /usr/src/app
WORKDIR /usr/src/app
ENV PATH /usr/src/app/node_modules/.bin:$PATH
COPY package.json /usr/src/app/package.json
RUN npm install
COPY . /usr/src/app
RUN PUBLIC_URL=/ npm run build

# Production environment.
FROM nginx:1.19-alpine
RUN rm -rf /etc/nginx/conf.d
COPY conf /etc/nginx
RUN mkdir -p /usr/share/nginx/html

COPY --from=builder /usr/src/app/dist /usr/share/nginx/html
EXPOSE 80
ADD ./prepare.sh ./
RUN chmod +x ./prepare.sh
CMD ["./prepare.sh"]