# Borra la configuración antigua de la máquina.
sudo ovs-vsctl del-br s1
sudo ovs-vsctl del-br s2
sudo ovs-dpctl del-dp ovs-system

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

# Creo el switch software ovswitch. (del para borrar)
sudo ovs-vsctl add-br ovs1
# Creo sus enlaces.
sudo ip link add eth0-h1 type veth peer name veth-h1
sudo ip link add eth0-h2 type veth peer name veth-h2

# Creo el segundo switch.
sudo ovs-vsctl add-br ovs2
# Creo sus enlaces.
sudo ip link add eth0-h3 type veth peer name veth-h3
sudo ip link add eth0-h4 type veth peer name veth-h4

# Mover las interfaces de las máquinas a los "namespaces".
sudo ip link set eth0-h1 netns h1
