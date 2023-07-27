#!/bin/bash

#Obtener la IP del usuario
MY_IP=$(curl -s https://checkip.amazonaws.com)
echo "MY ip is ${MY_IP}"

#Crear nuestro security group
#https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-sg.html
SG_JSON=$(aws ec2 create-security-group --group-name "mi-security-group12" --description "Se usa para habilitar acceso al puerto 22" --region us-west-2)

#Parsear el id de nuestro SG
SG=$(echo $SG_JSON | jq .GroupId | sed 's/"//g') 
echo "Usando el SG ${SG}"

#Modificar nuestro SG
aws ec2 authorize-security-group-ingress --group-id $SG --protocol tcp --port 80 --cidr ${MY_IP}/32 --region us-west-2 --output json

#Arrancar nuestra instancia
aws ec2 run-instances --image-id ami-03f65b8614a860c29 --key-name keypair-oregon --instance-type t2.micro --security-group-id $SG --region us-west-2 --user-data file://user_data.sh --output text

