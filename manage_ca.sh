#!/bin/bash
PATH_CA="ca"
PATH_SERVER="server"
PATH_CLIENT_CONFIG="client-configs"

EASYRSA="EasyRSA-3.0.4"
CURPATH=$(pwd)

if [ "$#" -eq "0" ]; then
        echo "./manage_ca [build-ca] [server-cert <domain>] [client-cert <name>]"
        exit 1
fi

function setup(){
    # Download easyrsa and add it to env
    if [ ! -d "${EASYRSA}" ]; then
        wget -q https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.4/${EASYRSA}.tgz
        tar xf ${EASYRSA}.tgz
        rm "${EASYRSA}".tgz
    fi
    cd "${EASYRSA}"
    export PATH=$PATH:`pwd`
    cd ${CURPATH}
}

# create CA (default validity time: 10 years)
if [ $1 = "build-ca" ]; then
        setup
        echo "Creating a new Certification Authority"
        if [ ! -d "$PATH_CA" ]; then
                mkdir $PATH_CA
        fi
        echo "COUNTRY"
        read EASYRSA_REQ_COUNTRY
        echo "PROVINCE"
        read EASYRSA_REQ_PROVINCE
        echo "CITY"
        read EASYRSA_REQ_CITY
        echo "ORG"
        read EASYRSA_REQ_ORG
        echo "EMAIL"
        read EASYRSA_REQ_EMAIL

        cd "${EASYRSA}"
        cp vars.example vars

        echo "set_var EASYRSA_REQ_COUNTRY       \"${EASYRSA_REQ_COUNTRY}\"" >> vars
        echo "set_var EASYRSA_REQ_PROVINCE       \"${EASYRSA_REQ_PROVINCE}\"" >>vars
        echo "set_var EASYRSA_REQ_CITY       \"${EASYRSA_REQ_CITY}\"" >> vars
        echo "set_var EASYRSA_REQ_ORG       \"${EASYRSA_REQ_ORG}\"" >> vars
        echo "set_var EASYRSA_REQ_EMAIL       \"${EASYRSA_REQ_EMAIL}\"" >> vars

        echo "RSA or EC algorithm? [rsa/ec]"
        read ALGO
        if [ $ALGO = "ec" ]; then
                echo "set_var EASYRSA_ALGO      $ALGO" >> vars
        elif [ $ALGO = "rsa" ]; then
                echo "set_var EASYRSA_ALGO      $ALGO" >> vars
        else
                echo "unknown parameter.. aborting."
                exit 1
        fi

        # set rsa key size to 4096 if you want
        echo "set_var EASYRSA_KEY_SIZE        2048" >> vars

        easyrsa init-pki
        easyrsa build-ca
        
        mv -f pki ../$PATH_CA
        
        cd ${CURPATH}
        if [ ! -d "$PATH_CLIENT_CONFIG" ]; then
                mkdir $PATH_CLIENT_CONFIG
                mkdir -p $PATH_CLIENT_CONFIG/keys
        fi
        
        cp ca/pki/ca.crt ./$PATH_CLIENT_CONFIG/keys/
        
        

elif [ $1 = "server-cert" ]; then
        cd ${CURPATH}
        # Check CA is existing
        if [ ! -d "$PATH_CA" ]; then
                echo "CA not existing, run FIRST ./manage_ca build-ca "
                exit 1
        fi

        setup

        #
        # create SERVER cert
        # 
        if [ ! -d "$PATH_SERVER" ]; then
                mkdir $PATH_SERVER
        fi
        
        if [ -z "$2" ];then
            echo "<domain> is missing as 2th argument. exiting."
            exit 1
        fi
        DOMAIN=$2
        echo "Creating a new server certificate for domain: $DOMAIN"
        
        #cd $PATH_SERVER
        cd $PATH_CA
        echo "Generating server certificate"
        #easyrsa init-pki
        easyrsa gen-req "$DOMAIN" nopass
        echo "Signing server certificate with CA"
        #cd ../$PATH_CA
        #easyrsa import-req ../$PATH_SERVER/pki/reqs/$DOMAIN.req
        easyrsa sign-req server "$DOMAIN"
        # Copy server cert and key to configs folder
        cp pki/issued/$DOMAIN.crt ../$PATH_SERVER/
        mv pki/private/$DOMAIN.key ../$PATH_SERVER/
        
        easyrsa gen-dh
        echo "Server crt and key successfully created and exported to server/"
        
elif [ $1 = "client-cert" ]; then
        #
        # create CLIENT cert
        #
        cd ${CURPATH}
        if [ ! -d "$PATH_CLIENT_CONFIG" ]; then
                mkdir $PATH_CLIENT_CONFIG
                mkdir $PATH_CLIENT_CONFIG/keys
        fi;
        setup        
        if [ -z "$2" ];then
            echo "<name> is missing as 2th argument. exiting."
            exit 1
        fi
        NAME=$2
        echo "Creating a new client certificate for domain: $NAME"
        
        cd $PATH_CA
        easyrsa gen-req "$NAME" nopass
        cp pki/private/$NAME.key ../$PATH_CLIENT_CONFIG/keys/
        echo "Signing client certificate by CA"
        easyrsa sign-req client "$NAME"
        cp pki/issued/$NAME.crt ../$PATH_CLIENT_CONFIG/keys/
        echo "crt and key in $PATH_CLIENT_CONFIG/keys"
else
    echo "./manage_ca [build-ca] [server-cert <domain>] [client-cert <name>]"
    exit 1
fi

######










