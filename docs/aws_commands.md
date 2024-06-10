# AWS commands

## Prerequisitos
Tener instalado [AWS CLI](https://docs.aws.amazon.com/es_es/cli/latest/userguide/getting-started-install.html).

- [Ejercicio 1](#ejercicio-1-lanzar-y-configurar-una-instancia-ec2)
- [Ejercicio 2](#ejercicio-2-subir-y-gestionar-archivos-en-s3)
- [Ejercicio 3](#ejercicio-3-configuración-básica-de-rds)
- [Ejercicio 4](#ejercicio-4-implementar-un-load-balancer-con-auto-scaling)

## Notas
No se incluye la creación de AMI, subnets o vpc pero, se pueden encontrar facílmente en la [Documentación Oficial](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/index.html#available-services).

## Ejercicio 1: Lanzar y Configurar una Instancia EC2
1. Configurar AWS CLI
```
aws configure
```
Va a solicitar los siguientes campos: `AWS Access Key ID`, `AWS Secret Access Key`, `Default region name` y `Default output format`. Ejemplo:
```
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: us-east-1
Default output format [None]: json
```

#### Opcional (Short-term credentials)
```
aws configure set aws_session_token fcZib3JpZ2luX2IQoJb3JpZ2luX2IQoJb3JpZ2luX2IQoJb3JpZ2luX2IQoJb3JpZVERYLONGSTRINGEXAMPLE
```

2. Crear un par de claves\
Dale un nombre al al archivo .pem y guardalo.
```
aws ec2 create-key-pair --key-name MyFirstKeyPair --query 'KeyMaterial' --output text > MyKeyPair.pem
```
Ahora otorga permisos de lectura (Linux).
```
chmod 400 MyFirstKeyPair.pem
```

3. Crear un Security Group
```
aws ec2 create-security-group --group-name my-sg --description "My security group" --vpc-id vpc-xxxxxxxx
```
Retorna el group id:
```
{
  "GroupId": "sg-903004f8"
}
```

4. Autorizar acceso SSH en el Security Group\
Para este caso, sera necesaria la IP publica, se puede usar el servicio [https://checkip.amazonaws.com](https://checkip.amazonaws.com) para obtenerla. Luego reemplazar `x.x.x.x/x` por ella.
```
aws ec2 authorize-security-group-ingress --group-id sg-xxxxxxxx --port 22 --cidr x.x.x.x/x
```

5. Lanzar una instancia EC2
```
aws ec2 run-instances --image-id ami-xxxxxxxx --count 1 --instance-type t3.large --key-name MyFirstKeyPair \
--security-group-ids sg-xxxxxxxx --subnet-id subnet-xxxxxxxx
```

## Ejercicio 2: Subir y Gestionar Archivos en S3
1. Crear un bucket S3
```
aws s3 mb s3://mybucketname --region us-east-1
```
2. Subir un archivo
```
aws s3 cp /home/user/files/example_file.txt s3://mybucketname
```
3. Generar una URL firmada\
Por defecto el acceso es de 1 hora, en este caso se le indican 2 horas.
```
aws s3 presign s3://mybucketname/example_file.txt --expires-in 7200
```

## Ejercicio 3: Configuración Básica de RDS
1. Crear una instancia RDS MySQL\
Para instancias diferentes a production, se puede utilizar la clase: `db.t2.large`
```
aws rds create-db-instance \
--db-instance-identifier my-db-instance-identifier \
--db-instance-class db.t3.large \
--vpc-security-group-ids sg-xxxxxxxx \
--engine mysql \
--engine-version 8.0 \
--master-username MyMasterUserName \
--master-user-password MySuperSecretPassword \
--allocated-storage 20 \
--backup-retention-period 7 \
--availability-zone us-east-1 \
--db-name my-db-name
```
2. Verifica que la instancia RDS esté en ejecución\
La flag `--query` es opcional. EL campo `DBInstanceStatus` indica el estado actual.
```
aws rds describe-db-instances --db-instance-identifier my-db-instance-identifier --query 'DBInstances[*].[DBInstanceStatus]'
```

## Ejercicio 4: Implementar un Load Balancer con Auto Scaling
1. Crear un Launch Configuration
```
aws autoscaling create-launch-configuration --launch-configuration-name my-launch-configuration-name \
--image-id ami-xxxxxxxx --instance-type t3.large --security-groups sg-xxxxxxxx --key-name MyFirstKeyPair
```

2. Crear un grupo de Auto Scaling
```
aws autoscaling create-auto-scaling-group --auto-scaling-group-name my-auto-scaling-group-name \
--launch-configuration-name my-launch-configuration-name --min-size 1 --max-size 5 \
--desired-capacity 3 --availability-zones us-east-1 --vpc-zone-identifier subnet-xxxxxxxx
```

3. Configurar el Load Balancer (ELB)
```
aws elbv2 create-load-balancer --name my-load-balancer-name --subnets subnet-xxxxxxxx --security-groups sg-xxxxxxxx
```

4. Crear un Target Group\
Copia el `TargetGroupArn` para usarlo en el siguiente punto.
```
aws elbv2 create-target-group --name my-target-group-name --protocol HTTPS --port 443 --target-type instance --vpc-id vpc-xxxxxxxx
```

5. Registrar instancias en el Target Group
```
aws elbv2 register-targets --target-group-arn copied-TargetGroupArn-value --targets Id=i-xxxxxxxx
```

6. Crear una política de Auto Scaling
```
aws autoscaling put-scaling-policy --auto-scaling-group-name my-auto-scaling-group-name \
--policy-name my-scaling-policy-name --policy-type TargetTrackingScaling --target-tracking-configuration file://config.json
```
