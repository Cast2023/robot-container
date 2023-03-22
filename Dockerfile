FROM python:3.10-slim-bullseye

WORKDIR /app

COPY ./requirements.txt .
COPY ./tasks.py .

RUN apt-get update && apt-get install -y wget unzip
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt-get install -y ./google-chrome-stable_current_amd64.deb && rm -rf ./google-chrome-stable_current_amd64.deb

RUN CHROMEDRIVER_VERSION=`wget --no-verbose --output-document - https://chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
    wget --no-verbose --output-document /tmp/chromedriver_linux64.zip http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
    unzip -qq /tmp/chromedriver_linux64.zip -d /opt/chromedriver && \
    rm -rf /tmp/chromedriver_linux64.zip && \
    chmod +x /opt/chromedriver/chromedriver && \
    ln -fs /opt/chromedriver/chromedriver /usr/local/bin/chromedriver
    
RUN apt-get purge -y unzip && apt-get autoclean

RUN pip install -r requirements.txt

CMD [ "invoke", "container-test"]