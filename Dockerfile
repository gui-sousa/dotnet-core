FROM mcr.microsoft.com/dotnet/aspnet:6.0.16-bullseye-slim-amd64
#FROM guisousa/dotnet-core:0.3

ENV CORECLR_NEWRELIC_HOME=/usr/local/newrelic-netcore20-agent
ENV NEW_RELIC_LICENSE_KEY=eu01xxc61f8fd6f40195c9a1326dba08134e8682
ENV NEW_RELIC_APP_NAME=entity

WORKDIR /home

#RUN sed -i s/deb.debian.org/archive.debian.org/g /etc/apt/sources.list
#RUN sed -i 's/stable\/updates/stable-security\/updates/' /etc/apt/sources.list
#RUN sed -i '/stretch-updates/d' /etc/apt/sources.list

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       ca-certificates \
       curl \
       wget \
    && rm -rf /var/lib/apt/lists/*

RUN curl -SL --output aspnetcore.tar.gz https://download.visualstudio.microsoft.com/download/pr/39c3ef4c-73c7-4248-8c54-0865d5feb8b2/3420b1ff6b0f36e63044d6f7a794b579/aspnetcore-runtime-3.1.32-linux-x64.tar.gz \
    && aspnetcore_version=3.1.32 \
    && aspnetcore_sha512='0aa2aceda3d0b9f6bf02456d4e4b917c221c4f18eff30c8b6418e7514681baa9bb9ccc6b8c78949a92664922db4fb2b2a0dac9da11f775aaef618d9c491bb319' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -zxf aspnetcore.tar.gz -C /usr/share/dotnet \
    && rm aspnetcore.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

RUN sed -i "/buster-updates/d" /etc/apt/sources.list \
&& apt-get update \
&& apt-get install -y wget ca-certificates gnupg \
&& echo "deb http://apt.newrelic.com/debian/ newrelic non-free" | tee /etc/apt/sources.list.d/newrelic.list \
&& wget http://download.newrelic.com/548C16BF.gpg \
&& apt-key add 548C16BF.gpg \
&& apt-get --allow-releaseinfo-change update \
&& apt-get update \
&& apt-get install -y newrelic-netcore20-agent

ENV PATH "$PATH:/usr/share/dotnet"

CMD /usr/local/newrelic-netcore20-agent/run.sh dotnet Bee.Entity.Services.dll