# run command given by arg 1 on all servers
for server in newhost1 newhost2 newhost3; do
    echo "Running:" "ssh $server '$1'"
    ssh $server "$1"
done
