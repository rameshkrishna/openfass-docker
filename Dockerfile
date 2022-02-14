FROM openfaas/of-watchdog:0.7.7 as watchdog
FROM python:3.7-slim-buster

COPY --from=watchdog /fwatchdog /usr/bin/fwatchdog
RUN chmod +x /usr/bin/fwatchdog


RUN apt-get -qy update 

# Add non root user
RUN addgroup --system app && adduser app --system --ingroup app
RUN chown app /home/app

USER app

ENV PATH=$PATH:/home/app/.local/bin

WORKDIR /home/app/

COPY p.py           .
COPY requirements.txt   .

USER root
USER root
RUN mkdir -p /var/openfaas/
COPY secrets /var/openfaas/secrets
RUN pip install -r requirements.txt

# Build the function directory and install any user-specified components
USER app



#install function code
USER root


RUN chown -R app:app ../


WORKDIR /home/app/

#configure WSGI server and healthcheck
USER app

ENV fprocess="python p.py"

ENV cgi_headers="true"
ENV mode="http"
ENV upstream_url="http://127.0.0.1:5000"

HEALTHCHECK --interval=5s CMD [ -e /tmp/.lock ] || exit 1

CMD ["fwatchdog"]
