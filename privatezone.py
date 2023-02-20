# Loop through the public IP addresses and prepare the AWS network
    for instance in aws_instance_info:
        aws_instance_public_ip = instance['public_ip']
        local_hostname = instance['local_hostname']
    ## Prepare the AWS network infrastructure for CDP Private
    # Create a hosted zone on AWS using Boto3
    client = boto3.client('route53')
    # Create the hosted zone
    response = client.create_hosted_zone(
        Name=local_zone,
        CallerReference=str(uuid.uuid4()),
        HostedZoneConfig={
            'Comment': 'CDP Private Hosted Zone',
            'PrivateZone': True
        },
        VPC={
            'VPCRegion': config['vars']['aws_region'],
            'VPCId': config['aws']['vpc_id']
        }
    )
    # Get the hosted zone id
    hosted_zone_id = response['HostedZone']['Id']
    # For each instance, create an A record with the local hostname
    for instance in aws_instance_info:
        response = client.change_resource_record_sets(
            HostedZoneId=hosted_zone_id,
            ChangeBatch={
                'Comment': 'CDP Private Hosted Zone',
                'Changes': [
                    {
                        'Action': 'UPSERT',
                        'ResourceRecordSet': {
                            'Name': instance['local_hostname'],
                            'Type': 'A',
                            'TTL': 300,
                            'ResourceRecords': [
                                {
                                    'Value': instance['private_ip']
                                },
                            ],
                        }
                    },
                    {
                        'Action': 'UPSERT',
                        'ResourceRecordSet': {
                            'Name': instance['wildcard'],
                            'Type': 'A',
                            'TTL': 300,
                            'ResourceRecords': [
                                {
                                    'Value': instance['private_ip']
                                },
                            ],
                        }
                    },
                ]
            }
        )
        # Check to see if the reverse lookup zone exists
        response = client.list_hosted_zones_by_name()
        # Check to see if the reverse lookup zone exists by looping over the response
        reverse_hosted_zone_id = ''
        for zone in response['HostedZones']:
            if instance['in-addr_arpa'] in zone['Name']:
                reverse_hosted_zone_id = zone['Id'].replace('/hostedzone/', '')
                break
        # If the reverse lookup zone does not exist, create it
        if reverse_hosted_zone_id == '':
            # create a hosted zone for the reverse lookup zone
            response = client.create_hosted_zone(
                Name=instance['in-addr_arpa'],
                CallerReference=str(uuid.uuid4()),
                HostedZoneConfig={
                    'Comment': 'CDP Private Hosted Zone',
                    'PrivateZone': True
                },
                VPC={
                    'VPCRegion': config['vars']['aws_region'],
                    'VPCId': config['aws']['vpc_id']
                }
            )
            # Get the hosted zone id
            reverse_hosted_zone_id = response['HostedZone']['Id'].replace('/hostedzone/', '')
        # Create the PTR record
        response = client.change_resource_record_sets(
            HostedZoneId=reverse_hosted_zone_id,
            ChangeBatch={
                'Comment': 'CDP Private Hosted Zone',
                'Changes': [
                    {
                        'Action': 'UPSERT',
                        'ResourceRecordSet': {
                            'Name': instance['arpa_hostname'],
                            'Type': 'PTR',
                            'TTL': 300,
                            'ResourceRecords': [
                                {
                                    'Value': instance['local_hostname']
                                },
                            ],
                        }
                    },
                ]
            }
        )
