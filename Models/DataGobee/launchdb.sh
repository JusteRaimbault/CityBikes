# launch mongod
# first create db with admin role
sudo mongod --dbpath `cat conf/dbpath` --bind_ip 127.0.0.1 --port `cat conf/dbport` --auth
