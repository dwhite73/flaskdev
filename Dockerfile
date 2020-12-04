#FROM bstocking/reporting:python
FROM python:latest

# Update the image and install required software
RUN apt-get -y update && apt-get -y upgrade && apt-get -y install python3-pip && apt-get -y install python3-venv && \
apt-get -y install nginx && apt-get -y install supervisor && \
pip3 install --upgrade pip setuptools

# Copy the Nginx and Supervisoe config files over
COPY PythonWeb /etc/nginx/sites-enabled/.
COPY PythonWeb.conf /etc/supervisor/conf.d/.
COPY Nginx.conf /etc/supervisor/conf.d/.

RUN rm -rf /etc/nginx/sites-enabled/default

RUN mkdir -p /var/log/PythonWeb

COPY pythonweb.err.log /var/log/PythonWeb/.
COPY pythonweb.out.log /var/log/PythonWeb/.


# Create new user
RUN useradd -d /home/webuser -ms /bin/bash webuser

# Add the python project folder
COPY --chown=webuser:webuser project /home/webuser

# Create the python3  virtual environment
RUN python3 -m venv /home/webuser/venv
RUN chown -R webuser:webuser /home/webuser

# Change to using the new ussers
USER webuser
WORKDIR /home/webuser

# Install the python project modules from the requirements file
RUN . /home/webuser/venv/bin/activate && pip install --no-cache-dir -r /home/webuser/PythonWeb/requirements.txt

# Change back to root user
USER root
WORKDIR /root

ENTRYPOINT service supervisor start && /bin/bash
