#!/bin/bash                                                                                                                                                                                                                                                                     
mac_name() { 
    get_random_num=
    get_random_wei=                                                                                                                                                                                                                                                          
    test ! -e /etc/config/scp/mac.txt && echo "no find mac.txt ,please check!" && exit
    get_random_num=$(cat /etc/config/scp/mac.txt | wc -l)
    if [ "${get_random_num}" == "0" ]
    then
        echo "list is null , please check list !" && exit
    fi
    get_random_wei=$(echo ${get_random_num} | wc -L)
    if [ "${get_random_wei}" != "1" ]
    then
        num=1
        while true
        do
            test_a=
            test_a=$(head -n 5 /dev/urandom 2>/dev/null | tr -dc "0123456789"  2>/dev/null | head -c1)
            if [ "${test_a}" != "0" ] && [ "${test_a}" -le "${get_random_wei}" ]
            then
                random_max=
                random_max="${test_a}"
                break
            fi
            if [ "${num}" == "100" ]
            then
                exit
            fi
            let num=num+1
        done
    else
        random_max=1
    fi
    num=1
    while true
    do
        test_b=
        test_b=$(head -n 5 /dev/urandom 2>/dev/null | tr -dc "0123456789"  2>/dev/null | head -c${random_max})
        if [ "${test_b}" != "0" ] && [ "${test_b}" -le "${get_random_num}" ]
        then
            host_name=
            wlan_mac=
            tmp_name_mac="$(sed -n "${test_b}p" /etc/config/scp/mac.txt | sed -n "1p" )"
            host_name=$(echo "${tmp_name_mac}" | cut -d '@' -f 1 | sed -n "1p")                                                                                                                                                                                                       
            wlan_mac="$(echo "${tmp_name_mac}" | cut -d '@' -f 2)$(hexdump -n 3 -e '/1 ":%02x"' /dev/urandom  | sed -n "1p")"
            if [ "${host_name}" != "" ] && [ "${wlan_mac}" != "" ] && [ "$(echo "${wlan_mac}" | wc -L)" == "17" ]
            then
                break
            fi
        fi
        if [ "${num}" == "100" ]
        then
            exit
        fi
        let num=num+1
    done
}

gain_relesse() {
    relese_num=
    test -e /etc/openwrt_release && relese_num=$(cat /etc/openwrt_release | grep 'DISTRIB_RELEASE' | cut -d '.' -f 1 | cut -d "'" -f 2)
    [ -z "${relese_num}" ] && echo "erro: cannot gain system verson !" && exit
    if [ "${relese_num}" == "18" ]
    then
        port_num=$(uci show | grep "wireless.@wifi-iface" | cut -d '.' -f 2 | cut -d '=' -f 1 | sort -u)
    else
        port_num=$(uci show | grep 'wireless.wifinet' | cut -d '.' -f 2 | cut -d '=' -f 1 | sort -u)
    fi
}

all_change() {
test_tr=
for i in ${port_num}
do
    wifi_ssid=$(uci get wireless."${i}".ssid 2>/dev/null)
    mac_name
    echo ""
    echo ""
    echo "change ${wifi_ssid}"
    echo ""
    tmp_wwan=$(uci get wireless."${i}".network)                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    old_hotname=$(uci get network."${tmp_wwan}".hostname 2>/dev/null)                                                                                                                                                                                                         
    uci set network."${tmp_wwan}".hostname="${host_name}"                                                                                                                                                                                                                     
    new_hotname=$(uci get network."${tmp_wwan}".hostname)                                                                                                                                                                                                                                                  
    if [ "${new_hotname}" != "" ]                                                                                                                                                                                                                   
    then                                                                                                                                                                                      
            echo "hostname change OK .                                                                                                                                                                                                                                     
            old name: ${old_hotname}                                                                                                                                                                                                                                         
            new name: ${new_hotname}"                                                                                                                                                                                                                                        
    else                                                                                                                                                                                                                               
            echo "erro: hostname not change!"
            test_tr="${test_tr} ${i}"  
            continue                                                                                                                                                                                                                         
    fi                                                                                                                                                                                                                           
                                                                                                                                                                                                                                                                            
    old_mac=$(uci get wireless."${i}".macaddr 2>/dev/null)                                                                                                                                                                                                
    uci set wireless."${i}".macaddr="${wlan_mac}"                                                                                                                                                                                                         
    new_mac=$(uci get wireless."${i}".macaddr)                                                                                                                                                                                                                                               
if [ "${old_mac}" != "${new_mac}" ]                                                                                                                                                                                                                                     
then                                                                                                                                                                                                                                                                    
        echo "macaddress change OK .                                                                                                                                                                                                                                   
        old mac: ${old_mac}                                                                                                                                                                                                                                              
        new mac: ${new_mac}"                                                                                                                                                                                                                                             
else                                                                                                                                                                                                                                                                    
        echo "erro: macaddress not change!"                                                                                                                                                                                                                              
fi 
done
uci commit wireless
uci commit network
}
num=1                                                                                                                                                                                                                                                                           
ssid_name="$*" 
if [ "${ssid_name}" == "all" ]
then
    gain_relesse
    [ -z "${port_num}" ] && echo "error: not foud wifi" && exit
    all_change
    num_while=0
    while true
    do
        if [ "${test_tr}" != "" ]
        then
            port_num="${test_tr}"
            all_change
            if [ "${test_tr}" != "" ]
            then
                continue
            fi 
        fi
        let num_while=num_while+1
        if [ "${num_while}" == "5" ]
        then
            if [ "${test_tr}" != "" ]
            then
                echo "* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *"
                for i in ${test_tr}
                do
                    wifi_ssid=$(uci get wireless."${i}".ssid 2>/dev/null)
                    echo ""
                    echo "${wifi_ssid} not chager"
                done
            fi
            exit
        fi
        sleep 1
    done
elif [ "${ssid_name}" != "" ]                                                                                                                                                                                                                                                     
then                                                                                                                                                                                                                                                                            
        mac_name                                                                                                                                                                                                                                                                
        ssid_num=$(uci show | grep "${ssid_name}" | cut -d '.' -f 2 | sed -n "1p")                                                                                                                                                                                          
        pci_name=$(uci get wireless."${ssid_num}".network)                                                                                                                                                                                                           
        old_hotname=$(uci get network."${pci_name}".hostname 2>/dev/null)                                                                                                                                                                                                         
        uci set network."${pci_name}".hostname="${host_name}"                                                                                                                                                                                                                     
        new_hotname=$(uci get network."${pci_name}".hostname)                                                                                                                                                                                                                     
        uci commit network                                                                                                                                                                                                                                                      
        if [ "${new_hotname}" != "" ]                                                                                                                                                                                                                             
        then                                                                                                                                                                                                                                                                    
                echo "hostname change OK .                                                                                                                                                                                                                                     
                old name: ${old_hotname}                                                                                                                                                                                                                                         
                new name: ${new_hotname}"                                                                                                                                                                                                                                        
        else                                                                                                                                                                                                                                                                    
                echo "erro: hostname not change!"                                                                                                                                                                                                                                
        fi                                                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                                
        old_mac=$(uci get wireless."${ssid_num}".macaddr 2>/dev/null)                                                                                                                                                                                                
        uci set wireless."${ssid_num}".macaddr="${wlan_mac}"                                                                                                                                                                                                         
        new_mac=$(uci get wireless."${ssid_num}".macaddr)                                                                                                                                                                                                            
        uci commit wireless                                                                                                                                                                                                                                                     
        if [ "${old_mac}" != "${new_mac}" ]                                                                                                                                                                                                                                     
        then                                                                                                                                                                                                                                                                    
                echo "macaddress change OK .                                                                                                                                                                                                                                   
                old mac: ${old_mac}                                                                                                                                                                                                                                              
                new mac: ${new_mac}"                                                                                                                                                                                                                                             
        else                                                                                                                                                                                                                                                                    
                echo "erro: macaddress not change!"                                                                                                                                                                                                                              
        fi 
fi
