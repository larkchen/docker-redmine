FROM bitnami/redmine:latest

RUN dpkg --get-selections | awk '{ print $1 }' > /dpkg.list.origin &&\
  apt-get update &&\
  apt-get install -y build-essential libmysqlclient-dev libpq-dev libmagickwand-dev &&\
  dpkg --get-selections | awk '{ print $1 }' > /dpkg.list.install &&\
  cat /dpkg.list.origin | while read line; do sed -i "/$line/d" /dpkg.list.install; done &&\
  cd /opt/bitnami/redmine &&\
  git clone https://github.com/alexbevi/redmine_knowledgebase.git plugins/redmine_knowledgebase &&\
  git clone https://github.com/peclik/clipboard_image_paste.git plugins/clipboard_image_paste &&\
  bundle install --no-deployment &&\
  bundle clean --force &&\
  rm -rf plugins/redmine_knowledgebase plugins/clipboard_image_paste &&\
  apt-get autoremove -y --purge $(cat /dpkg.list.install) &&\
  apt-get clean all &&\
  apt-get autoclean
 