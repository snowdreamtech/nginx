#!/bin/sh
set -e

NGINX_CONFIG_PATH="/etc/nginx"
NGINX_VHOST_PATH="${NGINX_CONFIG_PATH}/http.d"
NGINX_TEMPLATES_PATH="${NGINX_CONFIG_PATH}/templates"
NGINX_H5BP_PATH="${NGINX_CONFIG_PATH}/h5bp"


# NGINX_CLIENT_MAX_BODY_SIZE
if [ -n "${NGINX_CLIENT_MAX_BODY_SIZE}" ];then
{
    sed -i "s|client_max_body_size.*|client_max_body_size ${NGINX_CLIENT_MAX_BODY_SIZE};|g" "${NGINX_CONFIG_PATH}/nginx.conf"      
}
fi

# ACME_DEAFULT_CA 
if [ "${ACME_DEAFULT_CA}" ];then
    acme.sh --set-default-ca --server "${ACME_DEAFULT_CA}" >/dev/null 2>&1
fi

# ACME_EMAIL
if [ "${ACME_EMAIL}" ];then
    acme.sh --register-account -m "${ACME_EMAIL}" >/dev/null 2>&1
fi

COMMAND='acme.sh --issue'

# ACME_STANDALONE
if [ -n "${ACME_STANDALONE}" ];then
{
    if [ "${ACME_STANDALONE}" == "http" ];then
    {
        COMMAND="${COMMAND} --standalone"       
    }
    elif [ "${ACME_STANDALONE}" == "https" ];then
    {
        COMMAND="${COMMAND} --alpn"       
    }
    else
    {
        COMMAND="${COMMAND}"       
    }
    fi
}
fi

# ACME_DNS
if [ -n "${ACME_DNS}" ];then
{
    if [ "${ACME_DNS}" == "manual" ];then
    {    
        COMMAND="${COMMAND} --dns"       
    }
    else
    {
        COMMAND="${COMMAND} --dns ${ACME_DNS}"       
    }
    fi
}
fi

# ACME_KEYLENGTH
if [ -n "${ACME_KEYLENGTH}" ];then
{    
    COMMAND="${COMMAND} --keylength ${ACME_KEYLENGTH}"       
}
fi

# ACME_DOMAIN 
# ACME_DOMAINS
if [ -n "${ACME_DOMAIN}" ];then
{
    if [ "${ACME_WILDCARD}" == 1 ];then
    {
        COMMAND="${COMMAND} -d ${ACME_DOMAIN} -d *.${ACME_DOMAIN}"       
    }
    else
    {
        COMMAND="${COMMAND} -d ${ACME_DOMAIN}"         
    }
    fi
}
elif [ -n "${ACME_DOMAINS}" ];then
{
    set -- $(echo "${ACME_DOMAINS}" | tr ',' ' ' )
    ACME_DOMAIN="${1}"

    if [ "${ACME_WILDCARD}" == 1 ];then
    {
        COMMAND="${COMMAND} -d ${ACME_DOMAIN} -d *.${ACME_DOMAIN}"       
    }
    else
    {
        for domain in "$@"
        do
            COMMAND="${COMMAND} -d ${domain}"
        done 
           
    }
    fi
}
else
{
    echo "ACME_DOMAIN and ACME_DOMAINS unset."
}
fi

# ACME_WWW_ROOT
if [ -n "${ACME_WWW_ROOT}" ];then
{
    COMMAND="${COMMAND} -w ${ACME_WWW_ROOT}"       
}
fi

# ACME_DEBUG
if [ "${ACME_DEBUG}" -eq 1 ];then
{
    COMMAND="${COMMAND} --debug"       
}
fi

if [ -n "${ACME_DOMAIN}" ];then
{
    # acme.sh --issue
    sh -c "${COMMAND}"

    if [ $? -ne 0 ];then
    {
        echo "acme.sh --issue failed."
        exit
    }
    fi

    # acme.sh --install-cert
    acme.sh --install-cert -d "${ACME_DOMAIN}" \
            --key-file       "${ACME_SSL_PATH}"/"${ACME_DOMAIN}".key  \
            --cert-file       "${ACME_SSL_PATH}"/"${ACME_DOMAIN}".cert.cer  \
            --ca-file       "${ACME_SSL_PATH}"/"${ACME_DOMAIN}".ca.cer  \
            --fullchain-file "${ACME_SSL_PATH}"/"${ACME_DOMAIN}".fullchain.cer \
            --reloadcmd     "service nginx force-reload"    
        
    if [ $? -ne 0 ];then
    {
        echo "acme.sh --install-cert failed."
        exit
    }
    fi

    # copy default conf
    cp "${NGINX_TEMPLATES_PATH}/default.conf" "${NGINX_VHOST_PATH}/default.conf" 
    cp "${NGINX_TEMPLATES_PATH}/ssl.default.conf" "${NGINX_VHOST_PATH}/ssl.default.conf" 

    cp "${NGINX_H5BP_PATH}/tls/certificate_files_example.com.conf" "${NGINX_H5BP_PATH}/tls/certificate_files_${ACME_DOMAIN}.conf"
    sed -i "s|example\.com|${ACME_DOMAIN}|g" "${NGINX_H5BP_PATH}/tls/certificate_files_${ACME_DOMAIN}.conf"

    sed -i "s|example\.com|${ACME_DOMAIN}|g" "${NGINX_VHOST_PATH}/ssl.default.conf" 

    if [ "${NGINX_REDIRECT_WWW}" == "nonwww2www" ];then
    {
        cp "${NGINX_TEMPLATES_PATH}/example.com.http2https.nonwww2www.conf" "${NGINX_VHOST_PATH}/${ACME_DOMAIN}.conf" 
    }
    elif [  "${NGINX_REDIRECT_WWW}" == "www2nonwww" ];then 
    {
        cp "${NGINX_TEMPLATES_PATH}/example.com.http2https.www2nonwww.conf" "${NGINX_VHOST_PATH}/${ACME_DOMAIN}.conf" 
    }
    else
    {
        cp "${NGINX_TEMPLATES_PATH}/example.com.http2https.conf" "${NGINX_VHOST_PATH}/${ACME_DOMAIN}.conf" 
    }
    fi

    sed -i "s|example\.com|${ACME_DOMAIN}|g" "${NGINX_VHOST_PATH}/${ACME_DOMAIN}.conf" 

    /usr/sbin/nginx -t

    if [ $? -ne 0 ];then
    {
        echo "/usr/sbin/nginx -t failed."
        exit
    }
    fi
}
fi

#nginx 
/usr/sbin/nginx -c /etc/nginx/nginx.conf

# exec commands
if [ -n "$*" ]; then
    sh -c "$*"
fi

# keep the docker container running
# https://github.com/docker/compose/issues/1926#issuecomment-422351028
if [ "${KEEPALIVE}" -eq 1 ]; then
    trap : TERM INT
    tail -f /dev/null & wait
    # sleep infinity & wait
fi