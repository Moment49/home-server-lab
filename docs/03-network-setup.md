## Set the IP address to Static
# static IP, WiFi, Tailscale
# To set up the static IP for the router- using an MTN router, I did a some configuration on the 
# ubuntu server netplan config.
first to make changes to the network plan config files I needed a root privlege to the server as I could not modify 
the changes for the file. and given that it is a sensitve file I decided to create a hard complex password for the root user and enable only the required permission to the file uding sudo chmod 600 /path_to_netplan_config.yaml. I ensured that only the root had these priveleges aany other user do not get to have any privelege on the file object at all. Next, Instead of using the starter config file for netplan for the server provided but I decieded to write the yaml manifest for the networking configs myself, that whay I learn. I opened the file using nano netplan-config.yaml file and pasted these yaml. 
network:
  version: 2
  renderer: networkd  <--- Netplan backend serveice
  wifis:
    wlp2s0:   <-- wifi(router interface) name
      dhcp4: no
      dhcp6: no
      addresses: [192.168..../24]  <--- Ip address of the server(the subnet mask is dependent on your ISP)
      nameservers:
        addresses: [ISP_DNS_IP, GOOGLE_DNS_IP]  <---- (Set your ISP's DNS server address or use Google's DNS server address)
      access-points:
        ROUTER_SSID_NAME: <--- (Router SSID name)
          password: router_wifi_password <--- (Router wifi password)
      routes:
        - to: default
          via: 192.168....   <--- (Default gateway address of the router)
fir rendere choose the networkd as backend service for netplan because it tells the the network interfaces how they are to be set up while the networkManager is advaced way of setting it up and as such consumers more resources it is only suituablke for laptops, desktops and not servers that have headless compute. To test the config after setup I used sudo netplan try, initially I saw the error about multiple perssion warning to the config file suggesting that it is not security wise to allow multiple users to have read access to the file as sensitive information like password and router ssid name I displayed in plaintext thats why i decided to change the permissions to the file for only the root use for the access every other user has no access to in. After saving the configuratuion by pressing enter before the config revert to the default config file as there are 2 config files in the net plan but based on lexicographic order my created yaml file wouuld overide these chanegs, this was one of the tings I read and undertsnad about this. Afterwards I remotely shutdown the server and then powered it on to test if I can still access with the static IP i set and viola it worked. 

Next --> Installed Tailscale for remote access to server over the internet,


