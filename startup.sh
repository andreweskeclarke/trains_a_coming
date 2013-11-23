mkdir tmp
mkdir tmp/pids
mkdir tmp/sockets
mkdir log
bundle exec unicorn -c ./unicorn.rb -E development -D
sudo /etc/init.d/nginx start
