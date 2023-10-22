FROM ruby:3.2.2
WORKDIR /app
RUN gem install rails
COPY . /app
