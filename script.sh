# Borra la configuración antigua de la máquina.
#sudo ovs-vsctl del-br s1
#sudo ovs-vsctl del-br s2
#sudo ovs-dpctl del-dp ovs-system

# Creo los namespaces. (del para borrar)
sudo ip netns add h1
sudo ip netns add h2
sudo ip netns add h3
sudo ip netns add h4

# Activación de interfaz local.
sudo ip netns exec h1 ip link set dev lo up
sudo ip netns exec h2 ip link set dev lo up
sudo ip netns exec h3 ip link set dev lo up
sudo ip netns exec h4 ip link set dev lo up

# Creo el switch software ovswitch.
sudo ovs-vsctl add-br ovs1
sudo ovs-vsctl add-br ovs2

# Creo sus enlaces.
sudo ip link add eth0-h1 type veth peer name veth-ovs1-h1
sudo ip link add eth0-h2 type veth peer name veth-ovs1-h2
sudo ip link add eth0-h3 type veth peer name veth-ovs2-h3
sudo ip link add eth0-h4 type veth peer name veth-ovs2-h4
sudo ip link add veth-ovs1 type veth peer name veth-ovs2

# Mover las interfaces de las máquinas a los "namespaces".
sudo ip link set eth0-h1 netns h1
sudo ip link set eth0-h2 netns h2
sudo ip link set eth0-h3 netns h3
sudo ip link set eth0-h4 netns h4

# Conectar los extremos del veth al switch
sudo ovs-vsctl add-port ovs1 veth-ovs1-h1
sudo ovs-vsctl add-port ovs1 veth-ovs1-h2
sudo ovs-vsctl add-port ovs1 veth-ovs1
sudo ovs-vsctl add-port ovs2 veth-ovs2-h3
sudo ovs-vsctl add-port ovs2 veth-ovs2-h4
sudo ovs-vsctl add-port ovs2 veth-ovs2

# Activar interfaces namespaces
sudo ip link set dev veth-ovs1-h1 up
sudo ip netns exec h1 ip link set dev lo up
sudo ip netns exec h1 ip link set dev eth0-h1 up
sudo ip netns exec h1 ip address add 71.0.0.1/24 dev eth0-h1

sudo ip link set dev veth-ovs1-h2 up
sudo ip netns exec h2 ip link set dev lo up
sudo ip netns exec h2 ip link set dev eth0-h2 up
sudo ip netns exec h2 ip address add 71.0.0.2/24 dev eth0-h2

sudo ip link set dev veth-ovs2-h3 up
sudo ip netns exec h3 ip link set dev lo up
sudo ip netns exec h3 ip link set dev eth0-h3 up
sudo ip netns exec h3 ip address add 71.0.0.3/24 dev eth0-h3

sudo ip link set dev veth-ovs2-h4 up
sudo ip netns exec h4 ip link set dev lo up
sudo ip netns exec h4 ip link set dev eth0-h4 up
sudo ip netns exec h4 ip address add 71.0.0.4/24 dev eth0-h4

sudo ip link set dev veth-ovs1 up
sudo ip link set dev veth-ovs2 up

# Hago el ping de testeo.
#sudo ip netns exec h1 ping 71.0.0.2
