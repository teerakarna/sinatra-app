FROM ruby:2.6-alpine

EXPOSE 4567

WORKDIR /app

ADD ./app .

RUN gem install bundler:2.0.2 && \
    bundle install

CMD ["ruby", "server.rb"]
