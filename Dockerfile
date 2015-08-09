FROM python:2.7.10

RUN adduser --disabled-password --gecos '' r
ADD ./requirements.txt /app/requirements.txt
WORKDIR /app

RUN pip install -r ./requirements.txt

ADD . /app

EXPOSE 5000

USER r
CMD gunicorn ponyapi:app --log-file=- -b 0.0.0.0:5000 -w 4
