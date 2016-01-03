FROM alpine:3.3

ENV DEV_PACKAGES build-base postgresql-dev libxml2-dev libxslt-dev ruby-dev

ENV PACKAGES ruby ruby-bigdecimal ruby-io-console ruby-json ruby-irb \
  ca-certificates nodejs tzdata libpq libxml2 libxslt

# Skip installing gem documentation
RUN echo "gem: --no-rdoc --no-ri" >> "$HOME/.gemrc"

# Install packages and remove RI documentation
RUN apk --no-cache add --virtual build-dependencies $DEV_PACKAGES && \
    apk --no-cache add $PACKAGES

RUN mkdir -p /app
WORKDIR /app

# Install production gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && \
    bundle config --global build.nokogiri  "--use-system-libraries" && \
    bundle install --system --jobs 20 --without development test && \
    rm -rf /usr/lib/ruby/gems/*/cache/*

# Clean up build system
RUN apk del build-dependencies

# Set Rails to run in production
ENV RAILS_ENV production
ENV RACK_ENV production

# Copy the main application.
COPY . ./

# Precompile assets
RUN bundle exec rake assets:precompile

ENTRYPOINT ["bundle", "exec"]
CMD ["rails", "server", "-b", "0.0.0.0"]

