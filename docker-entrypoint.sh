#!/bin/sh
set -e

# ACME_DEAFULT_CA 
if [ "${ACME_DEAFULT_CA}" ];then
    acme.sh --set-default-ca --server "${ACME_DEAFULT_CA}" >/dev/null 2>&1
fi

# ACME_EMAIL
if [ "${ACME_EMAIL}" ];then
    acme.sh --register-account -m "${ACME_EMAIL}" >/dev/null 2>&1
fi

COMMAND='acme.sh  --issue'

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
    array=$(echo "${ACME_DOMAINS}" | tr ',' ' ' )
    ACME_DOMAIN=${array[0]}

    if [ "${ACME_WILDCARD}" == 1 ];then
    {
        COMMAND="${COMMAND} -d ${ACME_DOMAIN} -d *.${ACME_DOMAIN}"       
    }
    else
    {
        for domain in "${array[@]}"
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


# acme.sh --install
acme.sh --install-cert -d "${ACME_DOMAIN}" \
--key-file       "${ACME_SSL_PATH}"/"${ACME_DOMAIN}".key  \
--cert-file       "${ACME_SSL_PATH}"/"${ACME_DOMAIN}".cert.cer  \
--ca-file       "${ACME_SSL_PATH}"/"${ACME_DOMAIN}".ca.cer  \
--fullchain-file "${ACME_SSL_PATH}"/"${ACME_DOMAIN}".fullchain.cer \
--reloadcmd     "service nginx force-reload"

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