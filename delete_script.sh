# Borra la configuración antigua de la máquina.
#sudo ovs-vsctl del-br s1
#sudo ovs-vsctl del-br s2
#sudo ovs-dpctl del-dp ovs-system

# Borro los namespaces. (del para borrar)
sudo ip netns del h1
sudo ip netns del h2
sudo ip netns del h3
sudo ip netns del h4

# Borro los switch software ovswitch. (del para borrar)
sudo ovs-vsctl del-br ovs1
sudo ovs-vsctl del-br ovs2

# Borro sus enlaces.
sudo ip link del eth0-h1 type veth peer name veth-ovs1-h1
sudo ip link del eth0-h2 type veth peer name veth-ovs1-h2
sudo ip link del eth0-h3 type veth peer name veth-ovs2-h3
sudo ip link del eth0-h4 type veth peer name veth-ovs2-h4
sudo ip link add ovs1-ovs2 type veth peer name ovs12

# Borramos las conexiones de los extremos del switch al veth.
sudo ovs-vsctl del-port ovs1 veth-ovs1-h1
sudo ovs-vsctl del-port ovs1 veth-ovs1-h2
sudo ovs-vsctl del-port ovs2 veth-ovs2-h3
sudo ovs-vsctl del-port ovs2 veth-ovs2-h4
sudo ovs-vsctl del-port ovs1 veth-ovs1
sudo ovs-vsctl del-port ovs2 veth-ovs2

# Borrar la tabla de conexiones aprendidas en el switch.
sudo ovs-appctl fdb/flush ovs1
sudo ovs-appctl fdb/show ovs1
sudo ovs-appctl fdb/flush ovs2
sudo ovs-appctl fdb/show ovs2
