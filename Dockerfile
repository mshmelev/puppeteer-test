ARG core=mcr.microsoft.com/windows/servercore:ltsc2019
ARG target=mcr.microsoft.com/windows/servercore:ltsc2019
FROM $core as download

# --- Install NodeJS
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
ENV NODE_VERSION 14.15.4
RUN Invoke-WebRequest $('https://nodejs.org/dist/v{0}/node-v{0}-win-x64.zip' -f $env:NODE_VERSION) -OutFile 'node.zip' -UseBasicParsing ; \
    Expand-Archive node.zip -DestinationPath C:\ ; \
    Rename-Item -Path $('C:\node-v{0}-win-x64' -f $env:NODE_VERSION) -NewName 'C:\nodejs'

FROM $target
USER ContainerAdministrator
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
ENV NPM_CONFIG_LOGLEVEL info
COPY --from=download /nodejs /nodejs
RUN $env:PATH = 'C:\nodejs;{0}' -f $env:PATH ; \
    [Environment]::SetEnvironmentVariable('PATH', $env:PATH, [EnvironmentVariableTarget]::Machine)

# --- Install app    
RUN mkdir "C:\\app"
WORKDIR "C:\\app"
COPY . .
RUN npm install
CMD [ "node", "main.js" ]
