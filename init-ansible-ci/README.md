# Init Ansible CI

The Ansible CI Init composite action sets up an environment for running playbooks from [smartly-ansible](https://github.com/smartlyio/smartly-ansible) in Github Action

It performs the following actions:

- Installs all the necessary dependencies within the runner
- Sets up firework rules for accessing the LXD container
- Spins up a LXD container that can serve as the deployment target for Ansible playbook testing

Please refer to the `action.yml` for required inputs

The composite action also returns the IP address of the LXD container for SSH connection.
