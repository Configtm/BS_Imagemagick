FROM debian:latest

ENV http_proxy="http://192.168.100.100:3128/"
ENV https_proxy="http://192.168.100.100:3128/"
ENV no_proxy="localhost,127.0.0.1"
COPY startup.sh /Test


#RUN apt update && apt install -y curl libssl-dev libffi-dev

#RUN mkdir -p /opt/zoho/Imagemagick-7.1.1-46

#RUN curl -uadmin:cmVmdGtuOjAxOjE3NzUwNjE4ODA6M0hHcXJ6bGdxM01rc2tzaUZYOU1OSzdVam0z -L -O "http://10.65.150.52:8081/artifactory/demo/ImageMagick-binaries/Imagemagick-7.1.1-46.tar.gz"

#RUN tar -xzvf Imagemagick-7.1.1-46.tar.gz -C /opt/zoho/Imagemagick-7.1.1-46/

#CMD ["/bin/bash"]

# Placeholder for the test case script.
# Once you finalize the script and store it in your host machine,
# you can add a COPY instruction like this:
# COPY your_test_script.sh /opt/zoho/python-3.12.9/
#
# And then define how to run it using CMD or ENTRYPOINT, for example:
# CMD ["/bin/bash", "/opt/zoho/python-3.12.9/your_test_script.sh"]
