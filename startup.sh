sudo kill `cat ./tmp/pids/unicorn.pid`
sudo /etc/init.d/nginx stop
sudo kill `cat ./tmp/pids/nginx.pid`
sudo cp nginx.conf /etc/nginx/nginx.conf
mkdir tmp
mkdir tmp/pids
mkdir tmp/sockets
mkdir log
bundle exec unicorn -c ./unicorn.rb -E development -D
sudo /etc/init.d/nginx start
