FROM bitnami/minideb:latest

LABEL Team 4beework

ENV TZ=America/Sao_Paulo

RUN apt-get update \
&& apt-get install -y wget gpg apt-transport-https tzdata openntpd \
&& wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg \
&& mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ \
&& wget -q https://packages.microsoft.com/config/debian/10/prod.list \
&& mv prod.list /etc/apt/sources.list.d/microsoft-prod.list \
&& chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg \
&& chown root:root /etc/apt/sources.list.d/microsoft-prod.list \
&& apt -o Acquire::https::No-Cache=True -o Acquire::http::No-Cache=True update \
&& apt-get install -y aspnetcore-runtime-3.1 \
&& ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
&& apt-get autoremove \
&& apt-get clean

COPY ntpd.conf /etc/ntpd.conf

CMD /etc/init.d/openntpd start && tail -f /dev/null