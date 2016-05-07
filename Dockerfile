FROM conetix/wordpress-with-wp-cli

RUN apt-get update && apt-get install -y ruby2.1 git

COPY templates/wp-cli.yml .

ENV WPCLI_HOME /wpcli
RUN mkdir $WPCLI_HOME
WORKDIR $WPCLI_HOME

RUN gem2.1 install bundler
ADD . $WPCLI_HOME
RUN bundle install

WORKDIR /var/www/html
