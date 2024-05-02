### Syncing inventory and playbook to the Ansible server
To upload the inventory file and the playbook to Ansible server use `scp` (Secure Copy Protocol).

1. Make sure you are in the root directory that contains the `inventory` folder.
2. Use the following `scp` commands to copy the inventory folder and playbook to the Ansible server:

   ```bash
   scp -i secret/id_rsa -r inventory admin@x.x.x.x:~
   ```

These commands will upload the `inventory` directory incl. `install_windows_updates.yml` playbook to 
the home directory of the user `admin` on the server `x.x.x.x`.

### Executing the Playbook on the Ansible Server

1. SSH into Ansible server:
   
   ```bash
   ssh -i secret/id_rsa admin@x.x.x.x
   ```

2. Once logged in, navigate to the directory where you uploaded your playbook and inventory:
   
   ```bash
   cd ~
   ```

3. Run the playbook with the following command:

   ```bash
   cd ~/inventory
   ansible-playbook -i server.ini install_windows_updates.yml
   ```

This command tells Ansible to execute the `install_windows_updates.yml` playbook using the hosts 
defined in the `inventory/server.ini` file.