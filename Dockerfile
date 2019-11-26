FROM ruby:2.6-alpine

WORKDIR /app

ADD ./app .

RUN gem install bundler:2.0.2 && \
    bundle install

CMD ["/usr/local/bin/ruby server.rb"]
