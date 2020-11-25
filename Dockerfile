FROM node:10.16.2
COPY . /app
WORKDIR /app
RUN npm i hexo -g
RUN npm install 
EXPOSE 80