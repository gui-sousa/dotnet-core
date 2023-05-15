FROM guisousa/dotnet-core:0.3

ENV CORECLR_NEWRELIC_HOME=/usr/local/newrelic-netcore20-agent
ENV NEW_RELIC_LICENSE_KEY=eu01xxc61f8fd6f40195c9a1326dba08134e8682
ENV NEW_RELIC_APP_NAME=entity

WORKDIR /home

#RUN sed -i s/deb.debian.org/archive.debian.org/g /etc/apt/sources.list
#RUN sed -i 's/stable\/updates/stable-security\/updates/' /etc/apt/sources.list
#RUN sed -i '/stretch-updates/d' /etc/apt/sources.list

RUN sed -i "/buster-updates/d" /etc/apt/sources.list \
&& apt-get update \
&& apt-get install -y wget ca-certificates gnupg \
&& echo "deb http://apt.newrelic.com/debian/ newrelic non-free" | tee /etc/apt/sources.list.d/newrelic.list \
&& wget http://download.newrelic.com/548C16BF.gpg \
&& apt-key add 548C16BF.gpg \
&& apt-get --allow-releaseinfo-change update \
&& apt-get update \
&& apt-get install -y newrelic-netcore20-agent

CMD /usr/local/newrelic-netcore20-agent/run.sh dotnet Bee.Entity.Services.dll