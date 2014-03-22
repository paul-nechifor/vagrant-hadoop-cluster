# Connect to all VMs to establish the keys.
for i in {10..13}; do
    ssh -o 'StrictHostKeyChecking=no' 10.10.10.$i
done
