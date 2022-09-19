FROM  adobecoldfusion/coldfusion2021:2021.0.4
COPY ./lib/* /opt/coldfusion/cfusion/lib
COPY ./my-crossdomain.xml /opt/coldfusion/cfusion/wwwroot/crossdomain.xml
