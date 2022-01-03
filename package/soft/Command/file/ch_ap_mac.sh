#!/bin/bash
                                                                                                                                                                                                                                                                   
mac_name() { 
    get_random_num=
    get_random_wei=                                                                                                                                                                                                                                                          
    test ! -e /etc/config/scp/ap_mac.txt && echo "no find ap_mac.txt ,please check!" && exit
    get_random_num=$(cat /etc/config/scp/ap_mac.txt | wc -l)
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
            tmp_name_mac="$(sed -n "${test_b}p" /etc/config/scp/ap_mac.txt | sed -n "1p" )"
            host_name=$(echo "${tmp_name_mac}" | cut -d '^' -f 1 | sed -n "1p")
            if [ "${host_name}" == "CMCC" ] 
            then
                while true
                do
                    # test_f=$(head -n 5 /dev/urandom 2>/dev/null | tr -dc "34"  2>/dev/null | head -c1)
                    test_rand=$(head -n 5 /dev/urandom 2>/dev/null | tr -dc "a-zA-Z0-9"  2>/dev/null | head -c4)
                    host_name="${host_name}-${test_rand}"
                    [ ! -z "${host_name}" ] && break
                done
            elif [ "${host_name}" == "@PHICOMM" ] 
            then
                while true
                do
                    # test_f=$(head -n 5 /dev/urandom 2>/dev/null | tr -dc "345"  2>/dev/null | head -c1)
                    test_rand=$(head -n 5 /dev/urandom 2>/dev/null | tr -dc "a-zA-Z0-9"  2>/dev/null | head -c2)
                    host_name="${host_name}_${test_rand}"
                    [ ! -z "${host_name}" ] && break
                done
            else
                while true
                do
                    test_rand=$(head -n 5 /dev/urandom 2>/dev/null | tr -dc "A-F0-9"  2>/dev/null | head -c4)
                    host_name="${host_name}_${test_rand}"
                    [ ! -z "${host_name}" ] && break
                done               
            fi                                                                                                                                                                                                        
            wlan_mac="$(echo "${tmp_name_mac}" | cut -d '^' -f 2)$(hexdump -n 3 -e '/1 ":%02x"' /dev/urandom  | sed -n "1p")"
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
                                                                                                                                                                                                                                                                 
ap_num=$(uci show |  grep "'ap'" | cut -d '.' -f 2 )            
if [ "${ap_num}" != "" ]
then
    for num_wifi in ${ap_num}
    do
        mac_name
        old_name=$(uci get wireless.${num_wifi}.ssid)
        old_mac=$(uci get wireless.${num_wifi}.macaddr)
        uci set wireless.${num_wifi}.ssid="${host_name}"
        uci set wireless.${num_wifi}.macaddr="${wlan_mac}"
        uci commit wireless
        new_name=$(uci get wireless.${num_wifi}.ssid)
        if [ "${new_name}" != "" ]
        then
                echo "wifi name change OK .                                                                                                                                                                                                                                     
                old name: ${old_name}                                                                                                                                                                                                                                         
                new name: ${new_name}"    
        else
            echo "erro: hostname not change!"   
        fi
        new_mac=$(uci get wireless.${num_wifi}.macaddr)
        if [ "${old_mac}" != "${new_mac}" ]
        then
                echo "wifi macaddress change OK .                                                                                                                                                                                                                                   
                old mac: ${old_mac}                                                                                                                                                                                                                                              
                new mac: ${new_mac}"   
                echo ""                                                                                                                                                                                                                                          
        else                                                                                                                                                                                                                                                                    
                echo "erro: macaddress not change!"                                                                                                                                                                                                                              
        fi 
    done
fi
